# QuickOn 应用模板工具箱

通过该工具，可以快速生成QuickOn规范的应用镜像模板文件。

## 第一步：初始化应用元数据

```bash
mkdir demo-docker
cd demo-docker
docker run --rm -v $PWD:/quickon easysoft/template-toolkit init-json "ZenTao" "debian-11"
```

执行完命令后，会在当前目录生成 `app.json` 文件，这个文件需要根据具体的应用来修改，如下是示例修改的内容：

```diff
-     "Home": "https://<homepage>/",
+     "Home": "https://www.zentao.com/",

-     "Maintainer": "maintainer maintainer@email.com",
+     "Maintainer": "zhouyueqiu zhouyueqiu@easycorp.ltd",

-     "GitUrl": "https://github.com/<organization>/<app>",
+     "GitUrl": "https://github.com/easysoft/zentaopms",

-     "InstallDocUrl": "https://www.qucheng.com/app-install/install-zentao-<number>.html",
+     "InstallDocUrl": "https://www.qucheng.com/app-install/install-zentao-1231.html",
```

> **说明**
>
> - init-json 命令支持2个参数：
>   - 参数1: 应用名称
>   - 参数2: 镜像系统，目前支持  `debian-11` 和 `alpine`

## 第二步：生产应用模板文件

```bash
cd demo-docker
docker run --rm -v $PWD:/quickon easysoft/template-toolkit init-app

# 执行命令后，会进行模板初始化的操作，以下是输出内容：
14:41:29.61 INFO  ==> + Copy template directorys ...
 14:41:29.61 INFO  ==>  Prepare [ ./.github ] directory
 14:41:30.62 INFO  ==>  Prepare [ ./.template ] directory
 14:41:32.05 INFO  ==>  Prepare [ ./debian/prebuildfs ] directory
 14:41:33.06 INFO  ==>  Prepare [ ./debian/rootfs ] directory
 14:41:34.07 INFO  ==> + Render templates...
 14:41:34.07 INFO  ==>  Render github workflows config file [docker.yml]
 14:41:34.08 INFO  ==>  Render [ VERSION ] file
 14:41:35.11 INFO  ==>  Render [ Dockerfile ] file
 14:41:36.14 INFO  ==>  Render [ docker-compose.yml ] file
 14:41:37.17 INFO  ==>  Render [ Makefile ] file
 14:41:38.20 INFO  ==>  Preview Render [README.md] based on [document template files]
```

## 第三步：完善文档信息

文档模板目录是 `.template` 目录结构:

```bash

.template
├── app-desc.md          # 应用基础描述内容
├── app-envs.md          # 应用环境变量内容
├── app-extra-info.md    # 应用附加描述内容
├── app.json             # * 应用基础信息定义
├── make-extra-info.md   # make命令特殊说明
├── readme.md.tpl        # * readme.md 主模板文件
└── support-tags.md      # 应用tag只是说明

```

### 3.1 根据参数生成标签文档

前提：应用模板目录(.template)必须包含 `support-tags.md` 文件，如果没有则新建。

根据版本，URL信息生产标签的Markdown文档：

```bash
docker run --rm -v <应用源码根目录>:/quickon easysoft/template-toolkit addTag "0.12.9" "https://github.com/gogs/gogs/releases/tag/v0.12.9"
```

这条命令会检查添加的版本号是否已经在  `.template/suport-tags.md` 文件中，如果不存在则新增，新增内容如下：

```markdown
- [0.12.9](https://github.com/gogs/gogs/releases/tag/v0.12.9)
```

**注意：**

- 如果不存在  `.template/suport-tags.md` 文件，会新建，并添加如下内容：

```markdown
- [latest](https://github.com/gogs/gogs/tags/)
- [0.12.9](https://github.com/gogs/gogs/releases/tag/v0.12.9)
```

### 3.2 根据模板渲染readme.md文件

渲染readme.md文件

```bash
docker run --rm -v <应用源码根目录>:/quickon easysoft/template-toolkit render-readme -v
```

**说明：**

- 执行上面的命令后，会根据应用源码根目录的模板文件生成Markdown格式的readme.md文档，打印到标准输出。
