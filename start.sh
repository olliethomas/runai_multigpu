#!/bin/bash

apt install curl
apt install python3.9 python-is-python3
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

poetry install
poetry run pip uninstall torch torchvision torchaudio
poetry run pip install torch==1.12.0 torchvision==0.13.0 --extra-index-url https://download.pytorch.org/whl/cu113
python main.py "$@"