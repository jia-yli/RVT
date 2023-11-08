#!/bin/bash
DATA_DIR=/dataset/prophesee-gen1-demo-data/raw
DEST_DIR=/dataset/prophesee-gen1-demo-data/original-preprocess
NUM_PROCESSES=20  # set to the number of parallel processes to use
python preprocess_dataset.py ${DATA_DIR} ${DEST_DIR} conf_preprocess/representation/stacked_hist.yaml \
conf_preprocess/extraction/const_duration.yaml conf_preprocess/filter_gen1.yaml -ds gen1 -np ${NUM_PROCESSES}