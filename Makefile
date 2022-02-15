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

	helm upgrade \
		pastis-hosting \
		./src/applications/pastis-hosting \
		--atomic \
		--create-namespace \
		--dependency-update \
		--install \
		--namespace ph-pastis-hosting \
		--wait \
		--wait-for-jobs

login:
	argocd --grpc-web login --username admin --password $$(kubectl --namespace ph-argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode) argocd.pastis-hosting.net

password:
	kubectl --namespace ph-argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode

vault-policies:
	vault policy write ph-read ./src/vault/policies/ph-read.hcl
	vault policy write ph-write ./src/vault/policies/ph-write.hcl

vault-tokens:
	vault token create -policy=ph-read

vault-login-root:
	vault login token=s.VVztwjEdhI0rTcAbSkqpcfqE

vault-login-ph-read:
	vault login token=s.ggzosvQtmd8L0Q8HBL5EG2nt