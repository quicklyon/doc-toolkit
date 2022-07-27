export APP_NAME="template-toolkit"
export BUILD_DATE := $(shell date +'%Y%m%d')


help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## 构建镜像
	docker build --build-arg VERSION=$(BUILD_DATE) -t hub.qucheng.com/platform/$(APP_NAME):$(BUILD_DATE) -f Dockerfile .

push: ## push 镜像到 hub.qucheng.com
	docker push hub.qucheng.com/platform/$(APP_NAME):$(BUILD_DATE)
	docker tag hub.qucheng.com/platform/$(APP_NAME):$(BUILD_DATE) hub.qucheng.com/platform/$(APP_NAME)
	docker push hub.qucheng.com/platform/$(APP_NAME)
	

push-public: ## push 镜像到 hub.docker.com
	docker tag hub.qucheng.com/platform/$(APP_NAME):$(BUILD_DATE) easysoft/$(APP_NAME):$(BUILD_DATE)
	docker tag easysoft/$(APP_NAME):$(BUILD_DATE) easysoft/$(APP_NAME):latest
	docker push easysoft/$(APP_NAME):$(BUILD_DATE)
	docker push easysoft/$(APP_NAME):latest

