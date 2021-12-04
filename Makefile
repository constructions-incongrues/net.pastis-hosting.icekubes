k3d:
	k3d cluster start local || k3d cluster create local

bootstrap: k3d
	kubectl create namespace argocd
	helm upgrade --install --namespace argocd --atomic argo-cd charts/argo-cd/
	helm template apps | kubectl apply --wait -f -

portforward:
	kubectl --namespace argocd port-forward svc/argo-cd-argocd-server 8080:443

password:
	kubectl --namespace argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
	echo