#!/bin/bash -e
# used pip packages


pip_packages="nose numpy opencv-python tensorflow-gpu torch torchvision mxnet-cu##CUDA_VERSION##"
target_dir=./dali/test/python

one_config_only=true

do_once() {
    NUM_GPUS=$(nvidia-smi -L | wc -l)
}

test_body() {
    python test_RN50_data_fw_iterators.py --gpus ${NUM_GPUS} -b 13 --workers 3 --prefetch 2 -i 100 --epochs 2
    python test_RN50_data_fw_iterators.py --gpus ${NUM_GPUS} -b 13 --workers 3 --prefetch 2 -i 2 --epochs 2 --fp16

    nosetests --verbose test_fw_iterators_detection.py
    nosetests --verbose test_FW_iterators_shuffling.py
}

pushd ../..
source ./qa/test_template.sh
popd
