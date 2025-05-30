apiVersion: v1
kind: Service
metadata:
  name: {{ include "devops-assignment.fullname" . }}
  labels:
    {{- include "devops-assignment.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "devops-assignment.selectorLabels" . | nindent 4 }}
