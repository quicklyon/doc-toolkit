# QuickOn 应用文档工具箱

## 一、readme.md文档处理

### 1.1 生产readme模板文件

```bash
docker run --rm -v <应用源码根目录>:/quickon easysoft/doc-toolkit init-readme-template
```

执行成功会提示: `Initialization completed.`

查看代码根目录是否有 `.template` 目录结构:

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

### 1.1 根据参数生成标签文档

前提：应用模板目录(.template)必须包含 `support-tags.md` 文件，如果没有则新建。

根据版本，URL信息生产标签的Markdown文档：

```bash
docker run --rm -v <应用源码根目录>:/quickon easysoft/doc-toolkit addTag "0.12.9" "https://github.com/gogs/gogs/releases/tag/v0.12.9"
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

### 1.2 根据模板渲染readme.md文件

前提：应用的模板目录中必须包含并填写完整的 `app.json` 文件，这个是应用说明文档的元数据定义文件。

内容示例：

```json
{
    "Name": "Gogs",
    "Home": "https://gogs.io",
    "GitUrl": "https://github.com/gogs/gogs",
    "DockerfileUrl": "https://github.com/quicklyon/gogs-docker",
    "InstallDocUrl": "https://www.qucheng.com/app-install/install-gogs-127.html",
    "Docker": {
        "Name": "gogs",
        "Repo": "https://hub.docker.com/r/easysoft/gogs",
        "TagUrl": "https://hub.docker.com/r/easysoft/gogs/tags/"
    }
}
```

渲染readme.md文件

```bash
docker run --rm -v <应用源码根目录>:/quickon easysoft/doc-toolkit render-readme
```

**说明：**

- 执行上面的命令后，会根据应用源码根目录的模板文件生成Markdown格式的readme.md文档，打印到标准输出。
