.PHONY: help build

IMAGE_NAME ?= test

help:  ## Display this help
	@# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

test: ## Run the test suite
	./gradlew test

check: ## Run all checks
	./gradlew check

build: ## Build a fat jar at build/libs/app.jar
	./gradlew shadowJar

buildImage: build ## Build a docker image
	cp build/libs/app.jar dist/docker/app.jar
	cd dist/docker && docker buildx build -t ${IMAGE_NAME} -f Dockerfile .

buildImageNative: build ## Build a docker image containing a native GraalVM image
	cp build/libs/app.jar dist/docker/app.jar
	cd dist/docker && docker buildx build -t ${IMAGE_NAME}-native -f Dockerfile.native .
