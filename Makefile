argocd:
	-kubectl create namespace platform-argocd
	helm repo add argocd https://argoproj.github.io/argo-helm
	helm repo update
	cd src/charts/argocd && helm dependency update
	helm upgrade --install --namespace platform-argocd --atomic argocd src/charts/argocd/

platform: argocd
	kubectl apply --wait -f src/projects/platform/project.yaml
	helm template --dependency-update --wait --wait-for-jobs src/projects/platform | kubectl apply --wait -f -

bootstrap:
	-kubectl create namespace platform-argocd
	helm repo add argocd https://argoproj.github.io/argo-helm
	helm repo update
	cd src/charts/argocd && helm dependency update
	helm upgrade --install --namespace platform-argocd --atomic argocd src/charts/argocd/
	kubectl apply --wait -f src/apps/templates/platform/project.yaml
	kubectl apply --wait -f src/apps/templates/platform/applications/kasten.yaml
	sleep 30
	kubectl wait --for condition=established --timeout=60s crd profiles.config.kio.kasten.io
	kubectl wait --for condition=established --timeout=60s crd policies.config.kio.kasten.io
	kubectl apply --wait -f src/apps/templates/platform/applications/traefik.yaml
	sleep 30
	kubectl wait --for condition=established --timeout=60s crd policies.config.kio.kasten.io
	helm template --dependency-update --wait --wait-for-jobs src/apps | kubectl apply --wait -f -

password:
	kubectl --namespace platform-argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
	@echo

login:
	argocd --grpc-web login --username admin --password $$(kubectl --namespace platform-argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode) argocd.jeancloude.club