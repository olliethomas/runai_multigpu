#!/bin/bash

export TZ="Europe/Moscow"
export DEBIAN_FRONTEND="noninteractive"

apt update && apt upgrade
apt install curl -y
apt install software-properties-common -y
add-apt-repository ppa:deadsnakes/ppa -y
apt install python3.9 python3.9-distutils python-is-python3 -y
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
source $HOME/.poetry/env
poetry env use python3.9
poetry install
poetry run python -m pip uninstall torch torchvision torchaudio
poetry run python -m pip install torch==1.12.0 torchvision==0.13.0 --extra-index-url https://download.pytorch.org/whl/cu113
poetry run python main.py "$@"