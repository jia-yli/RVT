#!/usr/bin/bash

IMAGE_NAME="rvt-env:latest"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
WORK_DIR="/workspace"
SAVE_DIR="/home/$USER/project/workspace/rvt"

docker run -it --rm --ipc=host --gpus all \
  --name rvt-env \
  -v "${SCRIPT_DIR}/..":"/home/$USER/RVT" \
  -v /datasets/$USER:/dataset \
  -v ${SAVE_DIR}:${WORK_DIR} \
  ${IMAGE_NAME}

# docker run -it --rm --ipc=host --gpus all \
#   --name rvt-env --shm-size=2gb \
#   -v /datasets/$USER:/dataset \
#   -v ${SAVE_DIR}:${WORK_DIR} \
#   ${IMAGE_NAME}

# docker run -it --rm --ipc=host --gpus all ${IMAGE_NAME}