---
appEnvironment: ${app_environment}
existingSecret: devops-assignment
fullnameOverride: ${app_name}
ingress:
  enabled: true
  className: alb
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/certificate-arn: ${certificate_arn}
    alb.ingress.kubernetes.io/healthcheck-path: "/index.html"
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'
    alb.ingress.kubernetes.io/load-balancer-name: ${app_name}
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS-1-2-2017-01
    alb.ingress.kubernetes.io/ssl-redirect: '443'
    alb.ingress.kubernetes.io/target-type: ip
  hosts:
    - host: ${host_name}
      paths:
        - path: /
          pathType: Prefix
volumes:
  - name: index-html
    configMap:
      name: ${app_name}-index-html
  - name: env-vars
    configMap:
      name: ${app_name}-env-vars
volumeMounts:
  - name: index-html
    mountPath: /app/web/
    readOnly: true
