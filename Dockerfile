FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y git vim build-essential python3-dev python3-pip && \
    rm -rf /var/lib/apt/lists/*

COPY . /build

WORKDIR /build

RUN pip3 install --upgrade pip setuptools==68.0.0 wheel==0.40.0 --no-cache-dir
RUN pip3 install torch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2 --no-cache-dir
RUN pip3 install -r requirements.txt --no-cache-dir

# https://developer.nvidia.com/cuda-gpus
# for a rtx 2060: ARG TORCH_CUDA_ARCH_LIST="7.5"
ARG TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6+PTX"
RUN python3 setup_cuda.py bdist_wheel -d .