#!/bin/bash

export TZ="Europe/Moscow"
export DEBIAN_FRONTEND="noninteractive"

apt update && apt upgrade -y
apt install curl -y
#apt install software-properties-common -y --no-install-recommends
#add-apt-repository ppa:deadsnakes/ppa -y
#apt update && apt upgrade -y
#apt install -y --no-install-recommends $pythonVersions
apt install git -y
apt install -y --no-install-recommends \
    build-essential \
    curl \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1-dev \
    llvm \
    make \
    tk-dev \
    wget \
    xz-utils \
    zlib1g-dev
git clone --depth=1 https://github.com/pyenv/pyenv.git $HOME/.pyenv

export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"

eval "$(pyenv init --path)"
pyenv install -f $PYV


apt install python3-distutils python-is-python3 -y
apt purge -y --auto-remove software-properties-common && rm -rf /var/lib/apt/lists/*

curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
source $HOME/.poetry/env
poetry env use $PYV
poetry install
poetry run python -m pip uninstall --yes torch torchvision torchaudio
poetry run python -m pip install --no-input torch==1.12.0 torchvision==0.13.0 --extra-index-url https://download.pytorch.org/whl/cu113
poetry run python main.py "$@"