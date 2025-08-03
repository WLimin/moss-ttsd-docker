FROM pytorch/pytorch:2.7.1-cuda12.8-cudnn9-runtime
#python 3.11

ARG PYTORCH_VERSION=v2.7.1
ARG UID=1000
ARG ARG_USER_NAME=webui
ARG VENV_NAME="moss-ttsd"
ARG HF_ENDPOINT=https://hf-mirror.com
ARG HUGGINGFACE_MODEL="OpenMOSS/MOSS-TTSD-0.5B"
ARG APP_WORKDIR=/app/moss-ttsd

ENV HF_ENDPOINT=${HF_ENDPOINT}
ENV USER=$ARG_USER_NAME
ENV VENV=$VENV_NAME
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ENV DEBIAN_FRONTEN=noninteractive
ENV PYTHONUNBUFFERED=1
SHELL ["/bin/bash", "--login", "-c"]
ENV TZ=Asia/Shanghai
# 更新并安装需要的程序
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    sed -i -e 's#archive.ubuntu.com#mirrors.ustc.edu.cn#g' -e 's#security.ubuntu.com#mirrors.ustc.edu.cn#g' /etc/apt/sources.list \
    && apt-get update -y --fix-missing \
    && apt-get install -y git build-essential curl wget ffmpeg unzip git git-lfs sox libsox-dev tar bash vim \
    ca-certificates cmake libasound-dev \
    portaudio19-dev libportaudio2 libportaudiocpp0 \
    && DEBIAN_FRONTEND=noninteractive apt install -y tzdata \
    && apt-get clean && git lfs install && git config --global --add safe.directory '*' \
    && python -m pip config set global.index-url https://mirrors.aliyun.com/pypi/simple && useradd -l -u $UID -U -m -s /bin/bash ${USER}

ENV CONDA_DEFAULT_ENV=${VENV}
ENV PATH=/opt/conda/bin:/opt/conda/envs/${VENV}/bin:$PATH

WORKDIR ${APP_WORKDIR}
# Copy the requirements file for Python dependencies
COPY ./docker/requirements.txt ./docker/
# Install Python dependencies using aliyun's PyPI mirror and clean up cache to reduce image size
RUN --mount=type=cache,target=/root/.cache/pip  \
  python -m pip install --no-cache-dir -r docker/requirements.txt -i https://mirrors.aliyun.com/pypi/simple \
# 注意：下面指令安装flash-attn，需要系统安装 nvidia tools kit完整版，即带有nvcc编译器。本镜像不包含此内容。
# 解决办法1是分步构建，下载开发版编译后打包，或者2下载预编译文件并安装。
#  && python -m pip install --no-cache-dir flash-attn --no-build-isolation -i https://mirrors.aliyun.com/pypi/simple
# 下面的文件2025/07/24来自于 https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl。下载后，在下载目录运行 python3 -m http.server 8000
&&  python -m pip install --no-cache-dir --trusted-host 172.17.0.1 http://172.17.0.1:8000/flash_attn-2.8.2+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl -i https://mirrors.aliyun.com/pypi/simple

COPY ./docker/ ./docker
COPY ./MOSS-TTSD/ .
RUN rm -rf /root/.cache/pip && conda clean --all && chown -R ${USER}:${USER} ${APP_WORKDIR} && chmod +x ./docker/entrypoint.sh \
  && sed -i -e 's#"https://huggingface.co#"https://hf-mirror.com#g' /opt/conda/lib/python3.1*/site-packages/huggingface_hub/constants.py 

USER ${USER}
ENV HOME=/home/${USER}
WORKDIR $HOME

RUN /opt/conda/bin/python3.11 -m venv  --system-site-packages ${VENV} \
 && echo "source $HOME/${VENV}/bin/activate" >> ${HOME}/.bashrc && source $HOME/${VENV}/bin/activate
# && bash ./docker/patch.sh
ENV LD_LIBRARY_PATH=/opt/conda/lib/python3.11/site-packages/nvidia/cudnn/lib:$LD_LIBRARY_PATH
WORKDIR ${APP_WORKDIR}
ENV GRADIO_SERVER_NAME="0.0.0.0"
EXPOSE 7860 8080
ENTRYPOINT ["./docker/entrypoint.sh"]

