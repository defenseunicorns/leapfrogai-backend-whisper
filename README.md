# LeapfrogAI Whisper Backend

## Description

A LeapfrogAI API-compatible Whisper wrapper for audio transcription generation.

## Instructions

### Run Locally

For cloning a model locally and running the development backend.

#### Run Python Backend Locally

```bash
# Install FFMPEG locally
sudo apt install ffmpeg

# Setup Virtual Environment
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Clone Model
make fetch-model

# Start Model Backend
python main.py
```

### Docker Run

#### Local Image Build and Run

For local image building and running.

```bash
docker build -t ghcr.io/defenseunicorns/leapfrogai/whisper:latest .
# add the "--gpus all" flag for CUDA inferencing
docker run --rm --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -p 50051:50051 -d --name whisper ghcr.io/defenseunicorns/leapfrogai/whisper:latest
```

#### Remote Image Build and Run

For pulling a tagged image from the main release repository.

Where `<IMAGE_TAG>` is the released packages found [here](https://github.com/orgs/defenseunicorns/packages/container/package/leapfrogai%2Fwhisper).

```bash
docker build -t ghcr.io/defenseunicorns/leapfrogai/whisper:<IMAGE_TAG> .
# add the "--gpus all" flag for CUDA inferencing
docker run --rm --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -p 50051:50051 -d --name whisper ghcr.io/defenseunicorns/leapfrogai/whisper:<IMAGE_TAG>
```

### Docker Build and Push

This is for pushing a new image tag to the repository. Beforehand, ensure you run a `git tag <IMAGE_TAG>`.

```bash
make docker-build
make docker-push
```

### GPU Inferencing

For GPU inferencing, the environment variable `GPU_ENABLED` must be set to "True" via Zarf, Docker or CLI. Additionally, if using Docker, Docker must already have access to your GPUs via `nvidia-container-runtime` and `nvidia-container-toolkit`.