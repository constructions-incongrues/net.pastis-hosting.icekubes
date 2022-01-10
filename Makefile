bootstrap:
	-kubectl create namespace platform-argocd
	helm repo add argocd https://argoproj.github.io/argo-helm
	helm repo update
	cd src/charts/argocd && helm dependency update
	helm upgrade --install --namespace platform-argocd --atomic argo-cd src/charts/argocd/
	helm template --dependency-update --validate --wait --wait-for-jobs src/apps | kubectl apply --wait -f -

portforward:
	kubectl --namespace platform-argocd port-forward svc/argocd-argocd-server 8080:443

password:
	kubectl --namespace platform-argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
	@echo