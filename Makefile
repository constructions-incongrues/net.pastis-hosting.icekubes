k3d:
	-k3d cluster create local

bootstrap: k3d
	-helm install --atomic argo-cd charts/argo-cd/
	helm template apps/ | kubectl apply --wait -f -

portforward:
	kubectl port-forward svc/argo-cd-argocd-server 8080:443

password:
	kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode