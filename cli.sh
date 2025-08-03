#!/bin/bash
#
CONTAINER_NAME="moss-ttsd"
# 检查专属网络是否创建
DOCKER_NET=openwebui-net
docker network ls --format '{{.Name}}' | grep "${DOCKER_NET}"
if [ $? -ne 0 ]; then
    docker network create ${DOCKER_NET}
fi
#是否存在容器，存在则启动，否则创建
NS=$(docker ps -a --format '{{json .Names}},{{json .State}}' | grep "${CONTAINER_NAME}")
if [ $? -eq 0 ]; then
    # 已存在
    docker start ${CONTAINER_NAME}
    docker exec -it ${CONTAINER_NAME} /bin/bash
else
    source ./run.sh
    docker exec -it ${CONTAINER_NAME} /bin/bash
fi
:<<'REM'


REM
