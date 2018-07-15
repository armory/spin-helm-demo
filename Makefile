CHART_NAME=$(shell yq r chart/spin-helm-demo/Chart.yaml name)
CHART_VERSION=$(shell yq r chart/spin-helm-demo/Chart.yaml version)

APP_VERSION ?= $(shell yq r chart/spin-helm-demo/Chart.yaml appVersion)

CHART_BUCKET ?= spin-charts
SPINNAKER_URL ?= https://spin.spin/webhooks/webhook/spin-helm-repo

DOCKER_HOST ?= eu.gcr.io
DOCKER_PROJECT_ID ?= project-id
DOCKER_IMAGE ?= spin-helm-repo

docker-build:
	docker build -t $(DOCKER_HOST)/$(DOCKER_PROJECT_ID)/$(DOCKER_IMAGE):$(APP_VERSION) .
	docker tag $(DOCKER_HOST)/$(DOCKER_PROJECT_ID)/$(DOCKER_IMAGE):$(APP_VERSION) $(DOCKER_HOST)/$(DOCKER_PROJECT_ID)/$(DOCKER_IMAGE):latest

docker-push: docker-build
	docker push $(DOCKER_HOST)/$(DOCKER_PROJECT_ID)/$(DOCKER_IMAGE):$(APP_VERSION)
	docker push $(DOCKER_HOST)/$(DOCKER_PROJECT_ID)/$(DOCKER_IMAGE):latest

docker-trigger:
	curl -L -vvv -X POST \
		-k \
		-H"Content-Type: application/json" $(SPINNAKER_URL) \
		-d '{"artifacts": [{"type": "docker/image", "name": "$(CHART_NAME)", "reference": "$(DOCKER_HOST)/$(DOCKER_PROJECT_ID)/$(DOCKER_IMAGE):$(APP_VERSION)", "kind": "docker"}]}'

chart-compile:
	helm package chart/spin-helm-demo

chart-upload: chart-compile
	gsutil cp $(CHART_NAME)-$(CHART_VERSION).tgz gs://$(CHART_BUCKET)/$(CHART_NAME)/$(CHART_VERSION)/charts/
	gsutil cp -r values gs://$(CHART_BUCKET)/$(CHART_NAME)/$(CHART_VERSION)/values

chart-trigger:
	curl -L -vvv -X POST \
		-k \
		-H"Content-Type: application/json" $(SPINNAKER_URL) \
		-d '{"artifacts": [{"type": "gcs/object", "name": "gs://spin-charts/$(CHART_BUCKET)/0.1.7/charts/spin-helm-demo-0.1.7.tgz", "reference": "gs://$(CHART_BUCKET)/$(CHART_NAME)/$(CHART_VERSION)/charts/spin-helm-demo-$(CHART_VERSION).tgz", "kind": "gcs"}]}'