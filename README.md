# spin-helm-demo

This is the sample repository for the post [Deploying Helm Charts with Armory Spinnaker](https://kb.armory.io/kubernetes/using-spinnaker-and-helm/). If you're planning on using Helm charts with Spinnaker, these resources should serve as a good way to get started.

## What's included?

* A simple "application" running inside a Docker container. Located in `src/`.
* A basic Helm chart that includes a `Deployment` and `Service`
* A `Makefile` for automating various pieces of the process. You could take these commands and integrate them into your CI workflows.

## Dependencies

* `docker`
* `make`
* `helm`
* `aws`
* `curl`

## Making customizations

The `Makefile` exposes a few options that can be overridden. To override them, create a file called `.env` with the following contents:

```
CHART_BUCKET ?= spin-charts
SPINNAKER_URL ?= https://spin.spin/webhooks/webhook/spin-helm-repo

DOCKER_HOST ?= eu.gcr.io
DOCKER_PROJECT_ID ?= project-id
DOCKER_IMAGE ?= spin-helm-repo
```

Then, run `source .env` to make them all environment variables. `make` will override the default values with these variables.

Also be aware you'll need to update the image section of the charts values file to match the artifacts name in spinnaker;
```
image:
  name: spin-helm-demo
  pullPolicy: IfNotPresent
```