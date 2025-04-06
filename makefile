# This Makefile provides tasks for building, pushing, and deploying a Dockerized application.
#
# Variables:
#   VERSION - The version tag for the Docker image (default: v1.0.0).
#
# Targets:
#   build:
#     Builds the Docker image using the specified VERSION tag.
#     - Command: `docker build -t spigrig/hello-spyros:$(VERSION) app`
#
#   push:
#     Pushes the Docker image to the Docker registry.
#     - Depends on: build
#     - Command: `docker push spigrig/hello-spyros:$(VERSION)`
#
#   update-chart:
#     Updates the Helm chart values.yaml file with the specified VERSION tag.
#     - Command: `sed -i "s/^  tag: .*/  tag: $(VERSION)/" chart/values.yaml`
#
#   deploy:
#     Pushes the Docker image, updates the Helm chart, and prints a deployment confirmation message.
#     - Depends on: push, update-chart
#     - Command: `@echo "Deployment updated to version $(VERSION)"`
VERSION ?= v1.0.2

build:
	docker build -t spigrig/hello-spyros:$(VERSION) app

push: build
	docker push spigrig/hello-spyros:$(VERSION)

update-chart:
	sed -i "s/^  tag: .*/  tag: $(VERSION)/" chart/values.yaml

deploy: push update-chart 
	@echo "Deployment updated to version $(VERSION)"