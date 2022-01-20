{{/* Helm required labels */}}
{{- define "helm.labels" -}}
heritage: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "k10.common.matchLabels" . }}
{{- end -}}

{{- define "k10.common.matchLabels" -}}
app: {{ .Chart.Name }}
release: {{ .Release.Name }}
{{- end -}}