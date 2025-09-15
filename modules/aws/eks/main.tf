terraform {
  required_version = ">= 1.5.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.4"
    }
  }
}

# IAM Role for EKS Cluster
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_cluster" {
  name               = "avilangburd-eks-cluster"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

# EKS Control Cluster
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids             = var.subnet_ids
    endpoint_public_access = true
  }

  tags = var.tags

  depends_on = [aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy]
}

# EKS Cluster Addons
resource "aws_eks_addon" "addons" {
  for_each     = var.cluster_addons
  cluster_name = aws_eks_cluster.this.name
  addon_name   = each.key

  tags = var.tags

  depends_on = [aws_eks_node_group.this]
}

# IAM Role for EKS Workers
data "aws_iam_policy_document" "assume_role_workers" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_workers" {
  name               = "avilangburd-eks-workers"
  assume_role_policy = data.aws_iam_policy_document.assume_role_workers.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_workers_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_workers.name
}

resource "aws_iam_role_policy_attachment" "eks_workers_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_workers.name
}

resource "aws_iam_role_policy_attachment" "eks_workers_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_workers.name
}

# EKS Workers
data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.this.version}/amazon-linux-2/recommended/release_version"
}

resource "aws_eks_node_group" "this" {
  for_each = var.eks_workers

  cluster_name = aws_eks_cluster.this.name
  version      = aws_eks_cluster.this.version

  node_group_name = each.key
  node_role_arn   = aws_iam_role.eks_workers.arn

  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)
  instance_types  = each.value.instance_types

  subnet_ids = var.subnet_ids

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  update_config {
    max_unavailable = each.value.max_unavailable
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.eks_workers_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_workers_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_workers_AmazonEC2ContainerRegistryReadOnly,
  ]
}

# OIDC Provider for EKS
data "tls_certificate" "tls" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.tls.certificates[*].sha1_fingerprint
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer

  tags = var.tags
}
