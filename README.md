# Whsiper API server

## Description
A LeapfrogAI API-compatible Whisper backend for speech transcription.

## Instructions

* For GPU usage, latest CUDA drivers

### Install Locally

```shell
# Install FFMPEG locally
sudo apt install ffmpeg

# Setup Virtual Environment
python3 -m venv .venv
source .venv/bin/activate
make build-requirements

# Clone model locally
make fetch-model

# Run backend
python3 main.py
```

### Docker Build

```shell
make fetch-model
docker build -t leapfrogai/whisper:latest .
docker run --rm --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -p 8000:8000 -p 50052:50051 -d --name whisper leapfrogai/whisper:latest
```
