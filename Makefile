MODEL_NAME ?= openai/whisper-base

VERSION ?= $(shell git describe --abbrev=0 --tags | sed -e 's/^v//')
ifeq ($(VERSION),)
  VERSION := latest
endif

ARCH ?= $(shell uname -m | sed s/aarch64/arm64/ | sed s/x86_64/amd64/)

.PHONY: all

create-venv:
	python -m venv .venv

requirements-dev:
	python -m pip install -r requirements-dev.txt

requirements:
	pip-sync requirements.txt requirements-dev.txt

build-requirements:
	pip-compile -o requirements.txt pyproject.toml

build-requirements-dev:
	pip-compile --extra dev -o requirements-dev.txt pyproject.toml

fetch-model:
	ct2-transformers-converter --model ${MODEL_NAME} --output_dir .model --copy_files tokenizer.json --quantization float32

test:
	pytest **/*.py

dev:
	python main.py

docker-build:
	docker build -t ghcr.io/defenseunicorns/leapfrogai/whisper:${VERSION} --build-arg ARCH=${ARCH} .

docker-run:
	docker run -d -p 50051:50051 ghcr.io/defenseunicorns/leapfrogai/whisper:${VERSION}

docker-run-gpu:
	docker run --gpus device=0 -e GPU_ENABLED=true -d -p 50051:50051 ghcr.io/defenseunicorns/leapfrogai/whisper:${VERSION}

zarf-create:
	zarf package create . --confirm --set=PACKAGE_VERSION=${VERSION} --set=IMAGE_VERSION=${VERSION}

zarf-create-local-registry:
	zarf package create . --confirm --registry-override ghcr.io=localhost:5000 --set IMG=defenseunicorns/leapfrogai/whisper:${VERSION}

zarf-deploy:
	zarf package deploy --confirm zarf-package-whisper-${ARCH}-${VERSION}.tar.zst