FROM nvidia/cuda:12.2.2-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# 使用阿里云镜像源加速 apt
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|https://mirrors.tuna.tsinghua.edu.cn/ubuntu/|g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y \
    wget \
    git \
    python3 \
    python3-venv \
    python3-pip \
    build-essential \
    curl \
    ca-certificates \
    libffi-dev \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 使用pip清华源
RUN python3 -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

WORKDIR /webui

# 复制 stable-diffusion-webui 代码
COPY stable-diffusion-webui /webui

# 创建虚拟环境并安装依赖
RUN python3 -m venv venv \
    && /webui/venv/bin/pip install --upgrade pip setuptools wheel \
    && /webui/venv/bin/pip install -r requirements_versions.txt

# 创建模型目录
RUN mkdir -p /webui/models/Stable-diffusion

CMD ["python3", "launch.py", "--listen", "--skip-torch-cuda-test", "--xformers", "--no-gradio-queue"]
