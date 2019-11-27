## 自述

欢迎使用 project-launcher。
这是一个封装了 Docker 各种命令的辅助脚本，帮助您在开发过程中，优雅地启动或管理您的 Docker 工程。

## 意义

1. 缩短输入各种命令的时间。此外，脚本使用 Docker-Compose 来代替 Docker 命令来管理工程，以提高容器编排的可读性，您需要相关的知识储备。
2. 清晰的目录结构。使用此脚本前，需以下文规定的结构放置目录和编写 docker-compose.yml，但请相信，这样做会提高您工程的可读性而不是降低。
3. IDE 友好。使用 IDE 内置的终端时，对打开中的工程，绝大部分操作都可一行命令完成，脚本会自动处理路径关系，无需频繁手动 cd。

## 快速入门

首先，在克隆此仓库到本地后，请运行 `./pls install` 来安装此脚本（执行此命令后，会在 /usr/bin 放置一个此脚本的软链接，之后在任意位置，都可以直接使用本脚本）
```shellscript
# linux or mac
cd /usr/local && sudo git clone https://github.com/akirarika/project-launcher.git && cd project-launcher && sudo chmod +x ./pls && ./pls install
# wsl1
cd /usr/local && sudo git clone https://github.com/akirarika/project-launcher.git && cd project-launcher/wsl && sudo chmod +x ./pls && ./pls install
```

接着，您需要按照一下格式来编排目录

```shellscript
├── 容器 1
│   ├── 各种文件
│   └── Dockerfile
│       ...
├── 容器 2
├── 容器 3
│   ...
└── docker-compose.yml
```

其中，docker-compose.yml 中的容器名称请保持与容器目录所在的名称相同。示例：

```yaml
version: '3.2'
services:
  容器 1: # (此处名称请保持与创建的目录名相同)
    build: ./容器 1
    ports:
     - "12580:80"
    volumes:
       - ./容器 1:/project
    command: [ "/bin/bash", "/run.sh" ]
    restart: always
    
  容器 2:
    ...
    
  容器 3:
    ...
```

最后，在 IDE 中打开容器的目录，打开终端，输入 `pls up` 看看会发生什么吧！
（当执行此命令时，脚本会自动寻找上层目录中存在的 docker-compose.yml 文件，并在此执行 docker-compose 命令，并使用当前的目录名作为要操作的 Docker 容器。）

## 命令清单

注释：当指令可指定 [ProjectName] 时，若不指定，则取当前所在目录的目录名为工程名称，若工程名称为 global，则取 docker-compose.yml 同层的 .cntrLst 文件内容为工程名称。工程名称可一次指定多个，用空格分隔。如：`pls up "mysql redis php"`

- pls 进入容器 (通过 zsh)
- pls up [ProjectName] 构建运行容器。`docker-compose up --detach --build`
- pls zsh [ProjectName] 进入容器 (通过 zsh)
- pls bash [ProjectName] 进入容器 (通过 bash)
- pls sh [ProjectName] 进入容器 (通过 sh)
- pls debug [ProjectName] 以 debug 模式构建运行容器。`docker-compose up --build --force-recreate`
- pls stop [ProjectName] 停止运行容器。`docker-compose stop --timeout 12`
- pls restart [ProjectName] 重启容器。`docker-compose restart --timeout 12`
- pls init [ProjectName] 初始化容器。`docker-compose up --detach --build --force-recreate`
- pls clear 清理容器(停止并删除**所有**的容器)
- pls cleari 清理镜像(删除所有**未被容器使用**的镜像)
- pls install 安装 (使用户在任何位置仅需输入 `pls` 即可调用本脚本)
