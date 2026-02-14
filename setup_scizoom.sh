#!/bin/bash
set -e

eval "$(conda shell.bash hook)"
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

conda create -n scizoom python=3.10 -y
conda activate scizoom

conda install -y -c nvidia/label/cuda-12.8.0 "cuda-toolkit=12.8"

export CUDA_HOME=$CONDA_PREFIX
export PATH=$CONDA_PREFIX/bin:$PATH
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

nvcc --version

pip install --upgrade pip
pip install packaging ninja psutil wheel setuptools

pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu128

export FLASH_ATTENTION_FORCE_BUILD=TRUE
pip install flash-attn --no-build-isolation

pip install vllm
pip install h5py pandas numpy tqdm scikit-learn scipy matplotlib seaborn
pip install rouge_score bert_score protobuf
pip install ipykernel

python -m ipykernel install --user --name=scizoom --display-name "Python (scizoom)"
