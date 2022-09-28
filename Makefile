
.PHONY: help
help:	## - Show help message
	@printf "\033[32m\xE2\x9c\x93 usage: make [target]\n\n\033[0m"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY: nvim-debian
nvim-debian: ## Building ${NVIM_IMAGE_DEBIAN}
	@printf "\033[32m\xE2\x9c\x93 Building Debian ${NVIM_IMAGE_DEBIAN} container from source\033[0m"
	@docker buildx build -t ${NVIM_IMAGE_DEBIAN} -f ./nvim/Dockerfile.debian ./nvim/. --push

.PHONY: godev
godev: ## Build development container
	@printf "\033[32m\xE2\x9c\x93 Building development container from source\033[0m"
	@docker buildx build -t ${NVIM_IMAGE_ALPINE} -f ./nvim/Dockerfile.alpine ./nvim/.  --push
	@docker buildx build -t ${BASE_IMAGE_ALPINE} --no-cache --build-arg NVIM_IMAGE=${NVIM_IMAGE_ALPINE} ./basecontainer/.  --push
	@docker buildx build -t ${GODEV_IMAGE_ALPINE} --no-cache --build-arg BASE_IMAGE=${BASE_IMAGE_ALPINE} ./godevcontainer/.  --push

.PHONY: sync
sync: ## sync nvim to local ~/.config directory
	@rsync -r ./nvim/config/ ~/.config/nvim

.PHONY: nvim-local
nvim-local: ## Install nvim to local linux
	@sudo DOCKER_BUILDKIT=1 docker build --output type=local,dest=/usr/local -f ./nvim/Dockerfile.debian  .

.PHONY: run
run: ## Run development container
	@printf "\033[32m\xE2\x9c\x93 Run development container \033[0m"
	@. ./env && docker compose run -it godev
