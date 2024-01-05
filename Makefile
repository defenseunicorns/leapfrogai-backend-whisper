VERSION := $(shell git describe --abbrev=0 --tags 2> /dev/null )
ifeq ($(VERSION),)
  VERSION := latest
endif

ARCH := $(shell uname -m | sed s/aarch64/arm64/ | sed s/x86_64/amd64/)

MODEL ?= openai/whisper-base

create-venv:
	python -m venv .venv

activate-venv:
	source .venv/bin/activate

requirements-dev:
	python -m pip install -r requirements-dev.txt

requirements:
	pip-sync requirements.txt requirements-dev.txt

requirements-gpu:
	pip-sync requirements.txt requirements-gpu.txt

build-requirements:
	pip-compile -o requirements.txt pyproject.toml

build-requirements-gpu:
	pip-compile --extra gpu -o requirements-gpu.txt pyproject.toml

build-requirements-dev:
	pip-compile --extra dev -o requirements-dev.txt pyproject.toml

fetch-model:
	ct2-transformers-converter --model ${MODEL} --output_dir .model --copy_files tokenizer.json --quantization float32

test:
	pytest **/*.py

dev:
	python main.py

make docker-build:
	docker build -t ghcr.io/defenseunicorns/leapfrogai/whisper:${VERSION}-${ARCH} --build-arg ARCH=${ARCH} .

make docker-push:
	docker push ghcr.io/defenseunicorns/leapfrogai/whisper:${VERSION}-${ARCH}

make docker-build-gpu:
	docker build -f Dockerfile.gpu -t ghcr.io/defenseunicorns/leapfrogai/whisper-gpu:${VERSION}-${ARCH} --build-arg ARCH=${ARCH} .

make docker-push-gpu:
	docker push ghcr.io/defenseunicorns/leapfrogai/whisper-gpu:${VERSION}-${ARCH}
