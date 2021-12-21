.DEFAULT_GOAL:=help

# set default shell
SHELL=/bin/bash -o pipefail -o errexit

IMG=ghcr.io/bhojpur/platform-aks-guide:latest

build: ## Build docker image containing the required tools for the installation
	@docker build --quiet . -t ${IMG}

DOCKER_RUN_CMD = docker run -it --rm \
	--volume $$HOME/.kube:/root/.kube \
	--volume $$PWD:/bhojpur \
	${IMG} $(1)

install: ## Install Bhojpur.NET Platform
	@echo "Starting Bhojpur.NET Platform install process..."
	$(call DOCKER_RUN_CMD, --install)

uninstall: ## Uninstall Bhojpur.NET Platform
	@echo "Starting Bhojpur.NET Platform uninstall process..."
	@$(call DOCKER_RUN_CMD, --uninstall)

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: build install uninstall help
