MODEL_NAME ?= openai/whisper-base
REGISTRY ?= ghcr.io/defenseunicorns/leapfrogai/whisper
VERSION ?= $(shell git fetch --tags && git tag -l "*.*.*" | sort -V | tail -n 1 | sed -e 's/^v//')
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
	docker build -t ghcr.io/defenseunicorns/leapfrogai/whisper:${VERSION}-${ARCH} --build-arg ARCH=${ARCH} .

docker-run:
	docker run -d -p 50051:50051 ghcr.io/defenseunicorns/leapfrogai/whisper:${VERSION}-${ARCH}

docker-run-gpu:
	docker run --gpus device=0 -d -p 50051:50051 ghcr.io/defenseunicorns/leapfrogai/whisper:${VERSION}-${ARCH}

docker-push:
	docker push ghcr.io/defenseunicorns/leapfrogai/whisper:${VERSION}-${ARCH}

docker-publish:
	docker buildx install && \
	if docker buildx ls | grep -q 'whisper'; then \
	echo "Instance whisper already exists."; \
	else \
	docker buildx create --use --name whisper; \
	fi && \
	docker buildx build --push \
	--build-arg REGISTRY=${REGISTRY} \
	--build-arg VERSION=${VERSION} \
	--platform linux/arm64,linux/amd64 \
	-t ${REGISTRY}:${VERSION} . && \
	docker buildx rm whisper
