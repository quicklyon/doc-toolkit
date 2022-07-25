export BUILD_DATE := $(shell date +'%Y%m%d')


help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## 构建镜像
	docker build --build-arg VERSION=$(BUILD_DATE) -t hub.qucheng.com/platform/doc-toolkit:$(BUILD_DATE) -f Dockerfile .

push: ## push 镜像到 hub.qucheng.com
	docker push hub.qucheng.com/platform/doc-toolkit:$(BUILD_DATE)
	docker tag hub.qucheng.com/platform/doc-toolkit:$(BUILD_DATE) hub.qucheng.com/platform/doc-toolkit
	docker push hub.qucheng.com/platform/doc-toolkit
	

docker-push: ## push 镜像到 hub.docker.com
	docker tag hub.qucheng.com/platform/doc-toolkit:$(BUILD_DATE) easysoft/doc-toolkit:$(BUILD_DATE)
	docker tag easysoft/doc-toolkit:$(BUILD_DATE) easysoft/doc-toolkit:latest
	docker push easysoft/doc-toolkit:$(BUILD_DATE)
	docker push easysoft/doc-toolkit:latest

