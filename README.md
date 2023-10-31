# Whsiper API server

## Description
A LeapfrogAI API-compatible Whisper backend for speech transcription.

## Instructions

* For GPU usage, latest CUDA drivers

### Install Locally

```shell
# Setup Virtual Environment
python -m venv .venv
source .venv/bin/activate
make build-requirements

# Clone model locally
make fetch-model

# Run backend
python main.py
```

### Docker Build

```shell
docker build -t leapfrogai-whisper .
docker run --gpus all --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -p 0.0.0.0:8000:8000 -p 0.0.0.0:50051:50051 -d <image-id>
```
