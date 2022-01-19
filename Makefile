bootstrap: helm argocd argocd-applicationset

helm:
	helm repo add argo https://argoproj.github.io/argo-helm
	helm repo update

argocd:
	helm upgrade \
		argocd \
		argo/argo-cd \
		--atomic \
		--create-namespace \
		--dependency-update \
		--install \
		--namespace argocd \
		--version 3.30.0 \
		--values ./src/applications/argocd/values.yaml \
		--wait \
		--wait-for-jobs

argocd-applicationset:
	helm upgrade \
		argocd-applicationset \
		argo/argocd-applicationset \
		--atomic \
		--create-namespace \
		--dependency-update \
		--install \
		--namespace argocd \
		--version 1.9.0 \
		--wait \
		--wait-for-jobs

login:
	argocd --grpc-web login --username admin --password $$(kubectl --namespace argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode) argocd.pastis-hosting.net