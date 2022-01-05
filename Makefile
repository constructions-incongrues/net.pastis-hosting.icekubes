bootstrap:
	-kubectl create namespace argo-cd
	helm repo add argo-cd https://argoproj.github.io/argo-helm
	helm repo update
	cd src/charts/argo-cd && helm dependency update
	helm upgrade --install --namespace argo-cd --atomic argo-cd src/charts/argo-cd/
	helm template src/apps | kubectl apply --wait -f -

portforward:
	kubectl --namespace argo-cd port-forward svc/argocd-argocd-server 8080:443

password:
	kubectl --namespace argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
	@echo