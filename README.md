# moss-ttsd-docker
My dockerfile for moss-ttsd.
[MOSS-TTSD](https://github.com/OpenMOSS/MOSS-TTSD)是一个口语对话语音生成模型，实现了中英双语的高表现力对话语音生成，支持零样本多说话人音色克隆，声音事件控制以及长语音生成。
[MOSS-TTSD-v0.5](https://hf-mirror.com/fnlp/MOSS-TTSD-v0.5)模型库镜像地址。
Docker计划只支持Debian 13，torch 2.7.1+cuda128。

# 下载模型
0. 准备模型路径
    `mkdir fnlp; cd fnlp`
1. 下载模型权重 MOSS-TTSD-v0.5
    `git clone https://hf-mirror.com/fnlp/MOSS-TTSD-v0.5`
    本地路径：fnlp/MOSS-TTSD-v0.5

2. Download XY Tokenizer
    `wget -c https://hf-mirror.com/fnlp/XY_Tokenizer_TTSD_V0/resolve/main/xy_tokenizer.ckpt -O xy_tokenizer.ckpt`

3. 下载 flash_attn 预编译文件
    打开网站 https://github.com/Dao-AILab/flash-attention/releases，查找自己需要的版本文件。2025/07/24 是2.8.2版本。
    `wget -c https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl`
    下载后，在下载目录运行 `python3 -m http.server 8000` 并保持打开，提供构建镜像过程中 http://172.17.0.1:8000 服务能力。
# 构建镜像
    新打开终端，在当前目录下，执行 `./build.sh`，构建镜像 moss-ttsd-gpu:latest。
# 运行容器
    1. 执行`./run.sh`创建容器。打开 [http://localhost:7860/](http://localhost:7860/) 查看例子。
    2. 执行`./cli.sh`创建容器命令行。可以执行其他任务。
