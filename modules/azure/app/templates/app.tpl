---
appEnvironment: ${app_environment}
existingSecret: devops-assignment
fullnameOverride: ${app_name}
ingress:
  enabled: true
  className: azure-application-gateway
  annotations:
    appgw.ingress.kubernetes.io/health-probe-path: "/index.html"
    appgw.ingress.kubernetes.io/ssl-redirect: "true"
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: ${host_name}
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: ${host_name}-tls
      hosts:
        - ${host_name}
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
