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
else
    # 不存在
    # 宿主机是否有 nvidia GPU
    which nvidia-smi
    if [ $? -eq 0 ]; then #有gpu支持
        NV_GPU=1
    else
        NV_GPU=0
    fi

    if [ $NV_GPU -eq 1 ]; then #有gpu支持
      DEVICE_RUN=" --gpus all"
    else
      DEVICE_RUN=" -e CUDA_ENABLED=false "
    fi
    MODEL_PATH="fnlp/MOSS-TTSD-v0.5"
    SPT_CHECKPOINT_PATH="XY_Tokenizer/weights"
    APP_WORKDIR=/app/moss-ttsd
    docker run -d -it --name ${CONTAINER_NAME} \
        -p 7860:7860 \
        $DEVICE_RUN \
        --network=${DOCKER_NET} \
        -v $PWD/fnlp/MOSS-TTSD-v0.5:${APP_WORKDIR}/${MODEL_PATH} \
        -v $PWD/fnlp/xy_tokenizer.ckpt:${APP_WORKDIR}/${SPT_CHECKPOINT_PATH}/xy_tokenizer.ckpt \
        moss-ttsd-gpu:latest
fi
:<<'REM'


REM
