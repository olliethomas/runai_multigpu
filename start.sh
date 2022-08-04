#!/bin/bash

export TZ="Europe/Moscow"
export DEBIAN_FRONTEND="noninteractive"

pythonVersions='python3.6 python3.7 python3.8 python3.9 python3.10'

apt update && apt upgrade -y
apt install curl -y
apt install software-properties-common -y --no-install-recommends
add-apt-repository ppa:deadsnakes/ppa -y
apt update && apt upgrade -y
apt install -y --no-install-recommends $pythonVersions
apt install python3-distutils python-is-python3 -y
apt purge -y --auto-remove software-properties-common && rm -rf /var/lib/apt/lists/*

curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
source $HOME/.poetry/env
poetry install
poetry run python -m pip uninstall torch torchvision torchaudio
poetry run python -m pip install torch==1.12.0 torchvision==0.13.0 --extra-index-url https://download.pytorch.org/whl/cu113
poetry run python main.py "$@"