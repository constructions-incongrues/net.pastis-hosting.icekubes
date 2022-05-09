# Créer un secret

```yaml
apiVersion: v1
data:
  foo: YmFy
kind: Secret
metadata:
  creationTimestamp: null
  name: mysecret
```

```sh
cat ./etc/kubeseal/secret-template | kubeseal --controller-name=sealed-secrets --controller-namespace=ph-sealed-secrets -o yaml
```

```yaml
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  labels:
{{ include "helm.labels" . | indent 4 }}
  namespace: {{ .Release.Namespace }}
  name: {{ .Release.Name }}-secrets
spec:
  encryptedData:
  template:
    metadata:
      labels:
{{ include "helm.labels" . | indent 8 }}
      namespace: {{ .Release.Namespace }}
      name: {{ .Release.Name }}-secrets

```

MbGA&2pzH$6@MMR5fD^Pk9rZx#fPQZHt

# gcloud 

```sh
gcloud config set project ph-prod-1
gcloud container clusters get-credentials --zone europe-west1-b ph-prod-1-gke
```