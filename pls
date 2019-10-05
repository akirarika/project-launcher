#!/bin/bash
# Project Launcher

# 旧的获取方式，获取软链接的源路径
SHELL_PATH=$(cd "$(dirname "`readlink $0`")";pwd)
# 新的获取方式，获取文件所在路径，此方式对链接使用，会读取到错误的路径
# SHELL_PATH=$(cd "$(dirname "$0")";pwd)

# project_name -> 将操作的工程名称，在 docker-compose 的 services 节点定义
# 默认为当前终端所在的目录的目录名称，可手动指定 (通过传入参数2)
# 若参数2为 global 则执行 pls 所在目录中的 .cntrLst 中规定的所有工程
PROJECT_NAME=$2
if [ ! -n "$2" ]; then 
    PROJECT_NAME="$(basename "`pwd`")"
fi
if [ "$2" == "global" ]; then 
    PROJECT_NAME=`cat $(pwd)/../.cntrLst`
fi

cd `pwd` && cd ..

if [ `whoami` = "root" ];then
	echo "您不应当使用 Root 身份来运行脚本。"
    echo " - 当部分命令需要 Root 身份时，脚本会自动 sudo 并要求您赋权"
    exit
fi

# 打印环境变量是否正常
if [ "$1" == "test" ]; then 
    echo `pwd`
    echo $SHELL_PATH
    echo $PROJECT_NAME
    exit
fi

# 安装
# 使用户在任何位置仅需输入 `pls` 即可调用本脚本
if [ "$1" == "install" ]; then 
    sudo rm -f /usr/bin/pls
    sudo ln -s ${SHELL_PATH}/pls /usr/bin/pls
    exit
fi

# 获取脚本所在路径
if [ "$1" == "path" ]; then 
    echo "pls file: ${SHELL_PATH}/pls"
    exit
fi

# 进入容器 (通过 zsh)
if [ ! -n "$1" ]; then 
    sudo docker-compose exec ${PROJECT_NAME} /bin/zsh
    exit
fi

# 进入容器 (通过 zsh)
if [ "$1" == "zsh" ]; then 
    sudo docker-compose exec ${PROJECT_NAME} /bin/zsh
    exit
fi

# 进入容器 (通过 bash)
if [ "$1" == "bash" ]; then 
    sudo docker-compose exec ${PROJECT_NAME} /bin/bash
    exit
fi

# 进入容器 (通过 sh)
if [ "$1" == "sh" ]; then 
    sudo docker-compose exec ${PROJECT_NAME} /bin/sh
    exit
fi

# 构建运行容器 (建完毕后放置后台运行)
if [ "$1" == "up" ]; then 
    sudo docker-compose up --detach --build ${PROJECT_NAME}
    exit
fi

# 以 debug 模式构建运行容器 (即构建完毕后不在后台运行，打印容器内输出的日志)
if [ "$1" == "debug" ]; then 
    sudo docker-compose up --build --force-recreate ${PROJECT_NAME}
    exit
fi

# 停止运行容器
if [ "$1" == "stop" ]; then 
    sudo docker-compose stop --timeout 12 ${PROJECT_NAME}
    exit
fi

# 重启容器
if [ "$1" == "restart" ]; then 
    sudo docker-compose restart --timeout 12 ${PROJECT_NAME}
    exit
fi

# 初始化容器
if [ "$1" == "init" ]; then 
    sudo docker-compose up --detach --build --force-recreate ${PROJECT_NAME}
    exit
fi

# 清理容器（停止并删除**所有**的容器）
if [ "$1" == "clear" ]; then 
    sudo docker stop $(docker ps -a -q)
    sudo docker container prune -force
    exit
fi

# 清理镜像（删除所有**未被容器使用**的镜像）
if [ "$1" == "cleari" ]; then 
    sudo docker image prune --force --all
    exit
fi

# 帮助文档
if [ "$1" == "--help" ]; then 
    cat ${SHELL_PATH}/readme.md
    exit
fi

echo "此指令不存在，请输入 pls --help 获取帮助信息。"
