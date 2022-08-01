export APP_NAME=template-toolkit
export BUILD_DATE := $(shell date +'%Y%m%d')

help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## 国内构建镜像
	docker build --build-arg VERSION=$(BUILD_DATE) --build-arg IS_CHINA="true" -t hub.qucheng.com/platform/$(APP_NAME):$(BUILD_DATE) -f Dockerfile .
	docker tag hub.qucheng.com/platform/$(APP_NAME):$(BUILD_DATE) hub.qucheng.com/platform/$(APP_NAME)
	docker tag hub.qucheng.com/platform/$(APP_NAME) easysoft/$(APP_NAME):latest


build-public: ## 海外构建镜像
	docker build --build-arg VERSION=$(BUILD_DATE) --build-arg IS_CHINA="false" -t easysoft/$(APP_NAME):$(BUILD_DATE) -f Dockerfile .
	docker tag easysoft/$(APP_NAME):$(BUILD_DATE) easysoft/$(APP_NAME):latest

build-all: build build-public ## 构建所有镜像

push: ## push 镜像到 hub.qucheng.com
	docker push hub.qucheng.com/platform/$(APP_NAME):$(BUILD_DATE)
	docker push hub.qucheng.com/platform/$(APP_NAME)

push-public: ## push 镜像到 hub.docker.com
	docker push easysoft/$(APP_NAME):$(BUILD_DATE)
	docker push easysoft/$(APP_NAME):latest

push-sync-tcr: push-public ## 同步到腾讯镜像仓库
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):$(BUILD_DATE)
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):latest

push-all: push push-public ## push 镜像到所有仓库
