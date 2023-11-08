DATA_DIR=/dataset/prophesee-gen1/original-preprocess
MDL_CFG=tiny
GPU_IDS=0
BATCH_SIZE_PER_GPU=8
TRAIN_WORKERS_PER_GPU=0
EVAL_WORKERS_PER_GPU=0
python train.py model=rnndet dataset=gen1 dataset.path=${DATA_DIR} wandb.project_name=RVT \
wandb.group_name=gen1 +experiment/gen1="${MDL_CFG}.yaml" hardware.gpus=${GPU_IDS} \
batch_size.train=${BATCH_SIZE_PER_GPU} batch_size.eval=${BATCH_SIZE_PER_GPU} \
hardware.num_workers.train=${TRAIN_WORKERS_PER_GPU} hardware.num_workers.eval=${EVAL_WORKERS_PER_GPU}