MODEL ?= openai/whisper-base

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
	ct2-transformers-converter --model ${MODEL} --output_dir .model --copy_files tokenizer.json --quantization float32

test:
	pytest **/*.py

dev:
	python main.py
