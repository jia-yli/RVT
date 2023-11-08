# FROM continuumio/miniconda3:latest
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

ARG username
ARG uid
ARG gid

# Set environment variables.
## Set non-interactive to prevent asking for user inputs blocking image creation.
ENV DEBIAN_FRONTEND=noninteractive
## Set timezone as it is required by some packages.
ENV TZ=Europe/Berlin
## CUDA architectures, required by tiny-cuda-nn.
# ARG MY_GPU_ARCH=86
# ENV TCNN_CUDA_ARCHITECTURES=${MY_GPU_ARCH}
## CUDA Home, required to find CUDA in some packages.
ENV CUDA_HOME="/usr/local/cuda"

# Install basic apt packages.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    nano \
    vim \
    wget \
    curl

SHELL ["/bin/bash", "-c"]
WORKDIR /workspace

# Create non root user and setup environment.
## The user has exactly the same uid:gid as builder
## which allows read/write to mounted volumn
RUN groupadd -g ${gid} -o ${username}
RUN useradd -m -d /home/${username} -u ${uid} -g ${gid} -o ${username}

# Switch to new uer and workdir.
USER ${username}
WORKDIR /home/${username}

# Install conda
ARG CONDA_INSTALL_DIR=/home/${username}/miniconda3
RUN mkdir -p ${CONDA_INSTALL_DIR}
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ${CONDA_INSTALL_DIR}/miniconda.sh
RUN bash ${CONDA_INSTALL_DIR}/miniconda.sh -b -u -p ${CONDA_INSTALL_DIR}
RUN rm -rf ${CONDA_INSTALL_DIR}/miniconda.sh
RUN ${CONDA_INSTALL_DIR}/bin/conda init bash

# Set path to conda
ENV ORIG_PATH=${PATH}
ENV PATH=${CONDA_INSTALL_DIR}/bin:${PATH}

# ARG VENV_NAME=rvt
# Update conda and install packages
RUN conda update -y conda && \
    conda install python=3.9 pip

# RUN conda config --set channel_priority flexible

ARG CUDA_VERSION=11.8

RUN conda install -y pytorch==2.0.0 torchvision==0.15.0 torchaudio==2.0.0 pytorch-cuda=${CUDA_VERSION} -c pytorch -c nvidia
RUN conda install -y torchdata==0.6.0 -c pytorch
RUN python -m pip install pytorch-lightning==1.8.6 

RUN conda install -y h5py=3.8.0 blosc-hdf5-plugin=1.0.0 \
    hydra-core=1.3.2 einops=0.6.0 tqdm numba -c conda-forge

RUN python -m pip install wandb==0.14.0 pandas==1.5.3 \
    plotly==5.13.1 opencv-python==4.6.0.66 tabulate==0.9.0 \
    pycocotools==2.0.6 bbox-visualizer==0.1.0 StrEnum==0.4.10
RUN python -m pip install 'git+https://github.com/facebookresearch/detectron2.git'

ENV PATH=$ORIG_PATH

# additional packages
USER root
RUN apt-get install -y --no-install-recommends \
    libgl1-mesa-glx \
    libglib2.0-0

USER ${username}

ENTRYPOINT unset ORIG_PATH && /bin/bash
