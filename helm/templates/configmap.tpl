apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "devops-assignment.fullname" . }}-index-html
  labels:
    {{- include "devops-assignment.labels" . | nindent 4 }}
data:
{{ (.Files.Glob "index.html").AsConfig | indent 2 }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "devops-assignment.fullname" . }}-env-vars
  labels:
    {{- include "devops-assignment.labels" . | nindent 4 }}
data:
  APP_ENVIRONMENT: {{ .Values.appEnvironment | quote }}
