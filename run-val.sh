DATA_DIR=/dataset/prophesee-gen1/original-preprocess
CKPT_PATH=/workspace/check-points/pre-trained/gen1/rvt-b.ckpt
MDL_CFG=base
USE_TEST=1
GPU_ID=0
python validation.py dataset=gen1 dataset.path=${DATA_DIR} checkpoint=${CKPT_PATH} \
use_test_set=${USE_TEST} hardware.gpus=${GPU_ID} +experiment/gen1="${MDL_CFG}.yaml" \
batch_size.eval=8 model.postprocess.confidence_threshold=0.001