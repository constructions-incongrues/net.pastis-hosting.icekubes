bootstrap:
	kubectl create namespace argocd
	helm upgrade --install --namespace argocd --atomic argocd charts/argo-cd/
	helm template apps | kubectl apply --wait -f -

portforward:
	kubectl --namespace argocd port-forward svc/argocd-argocd-server 8080:443

password:
	kubectl --namespace argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
	@echo