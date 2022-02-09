bootstrap:
	helm upgrade \
		argocd \
		./src/applications/argocd \
		--atomic \
		--create-namespace \
		--dependency-update \
		--install \
		--namespace ph-argocd \
		--wait \
		--wait-for-jobs

login:
	argocd --grpc-web login --username admin --password $$(kubectl --namespace argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode) argocd.pastis-hosting.net

password:
	kubectl --namespace argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode