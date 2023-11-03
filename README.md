# LeapfrogAI Whisper Backend

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
docker build -t leapfrogai-whisper .

# GPU Run
docker run --gpus all --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -p 0.0.0.0:50051:50051 -d <image-id>

# CPU Run
docker run --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -p 0.0.0.0:50051:50051 -d <image-id>
```
