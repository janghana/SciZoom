#!/bin/bash
set -e

# 1. Conda 초기화
eval "$(conda shell.bash hook)"
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# 2. 환경 생성
conda create -n scizoom python=3.10 -y
conda activate scizoom

conda install -y -c nvidia/label/cuda-12.8.0 "cuda-toolkit=12.8"

# 4. 환경 변수 강제 설정 (Conda에 설치된 12.8 컴파일러를 쓰도록 유도)
export CUDA_HOME=$CONDA_PREFIX
export PATH=$CONDA_PREFIX/bin:$PATH
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

echo "=== NVCC 버전 확인 (12.8 이어야 함) ==="
nvcc --version

# 5. 빌드 필수 도구 설치
pip install --upgrade pip
pip install packaging ninja psutil wheel setuptools

# 6. PyTorch Nightly (CUDA 12.8) 설치
pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu128

# 7. Flash Attention 빌드 및 설치
export FLASH_ATTENTION_FORCE_BUILD=TRUE
pip install flash-attn --no-build-isolation

# 8. 나머지 라이브러리 설치 (vLLM 최신 버전 포함)
pip install vllm
pip install h5py pandas numpy tqdm scikit-learn scipy matplotlib seaborn
pip install rouge_score bert_score protobuf
pip install ipykernel

# 9. 커널 등록
python -m ipykernel install --user --name=scizoom --display-name "Python (scizoom)"