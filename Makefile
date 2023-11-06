VERSION ?= $(shell git describe --abbrev=0 --tags)

create-venv:
	python3 -m venv .venv

activate-venv:
	source .venv/bin/activate

requirements-dev:
	python3 -m pip install -r requirements-dev.txt

requirements:
	pip-sync requirements.txt requirements-dev.txt

build-requirements:
	pip-compile -o requirements.txt pyproject.toml

build-requirements-dev:
	pip-compile --extra dev -o requirements-dev.txt pyproject.toml

fetch-model:
	pip install openai-whisper
	mkdir -p .model
	python3 src/get_model.py

test:
	pytest **/*.py

dev:
	python3 main.py

make docker-build:
	docker build -t ghcr.io/defenseunicorns/leapfrogai/whisper:${VERSION} .

make docker-push:
	docker push ghcr.io/defenseunicorns/leapfrogai/whisper:${VERSION}