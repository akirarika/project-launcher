#!/bin/bash
# Project Launcher

SHELL_PATH=$(cd "$(dirname "`readlink $0`")";pwd)

PROJECT_NAME=$2
if [ ! -n "$2" ]; then 
    PROJECT_NAME="$(basename "`pwd`")"
fi
if [ "$2" == "-g" ]; then 
    PROJECT_NAME=`cat $(pwd)/../.cntrLst`
fi

cd `pwd` && cd ..

if [ "$1" == "test" ]; then 
    echo `pwd`
    echo $SHELL_PATH
    echo $PROJECT_NAME
    exit
fi

if [ "$1" == "install" ]; then 
    sudo rm -f /usr/bin/pls
    sudo ln -s ${SHELL_PATH}/pls /usr/bin/pls
    exit
fi

if [ "$1" == "path" ]; then 
    echo "pls file: ${SHELL_PATH}/pls"
    exit
fi

if [ ! -n "$1" ]; then 
    sudo docker-compose exec ${PROJECT_NAME} /bin/zsh
    exit
fi

if [ "$1" == "zsh" ]; then 
    sudo docker-compose exec ${PROJECT_NAME} /bin/zsh
    exit
fi

if [ "$1" == "bash" ]; then 
    sudo docker-compose exec ${PROJECT_NAME} /bin/bash
    exit
fi

if [ "$1" == "sh" ]; then 
    sudo docker-compose exec ${PROJECT_NAME} /bin/sh
    exit
fi

if [ "$1" == "up" ]; then 
    sudo docker-compose up --detach --build ${PROJECT_NAME}
    exit
fi

if [ "$1" == "debug" ]; then 
    sudo docker-compose up --build --force-recreate ${PROJECT_NAME}
    exit
fi

if [ "$1" == "stop" ]; then 
    sudo docker-compose stop --timeout 12 ${PROJECT_NAME}
    exit
fi

if [ "$1" == "restart" ]; then 
    sudo docker-compose restart --timeout 12 ${PROJECT_NAME}
    exit
fi

if [ "$1" == "init" ]; then 
    sudo docker-compose up --detach --build --force-recreate ${PROJECT_NAME}
    exit
fi

if [ "$1" == "clear" ]; then 
    sudo docker stop $(sudo docker ps -a -q)
    sudo docker container prune --force
    exit
fi

if [ "$1" == "cleari" ]; then 
    sudo docker image prune --force --all
    exit
fi

if [ "$1" == "--help" ]; then 
    cat ${SHELL_PATH}/readme.md
    exit
fi

echo "此指令不存在，请输入 pls --help 获取帮助信息。"
