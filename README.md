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
export CHART_BUCKET=my-chart-bucket
export DOCKER_REPO=dockerhubusername/spin-helm-demo
export SPINNAKER_API=https://mycoolspinnaker.spinnaker.io
```

Then, run `source .env` to make them all environment variables. `make` will override the default values with these variables.