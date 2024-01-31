# LeapfrogAI Whisper Backend

## Description

A LeapfrogAI API-compatible Whisper wrapper for audio transcription generation.

## Usage

See [instructions](#instructions) to get the backend up and running. Then, use the [LeapfrogAI API server](https://github.com/defenseunicorns/leapfrogai-api) to interact with the backend.

## Instructions

The instructions in this section assume the following:

1. Properly installed and configured Python 3.11.x, to include its development tools
2. The LeapfrogAI API server is deployed and running

<details>
<summary><b>GPU Variation</b></summary>
<br/>
The following are additional assumptions for GPU inferencing:

3. You have properly installed one or more NVIDIA GPUs and GPU drivers
4. You have properly installed and configured the [cuda-toolkit](https://developer.nvidia.com/cuda-toolkit) and [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html)
</details>

### Run Locally

<details>
<summary><b>GPU Variation</b></summary>
<br/>
The following additional variables must be exported for local GPU inferencing:

```bash
# enable GPU switch
export GPU_ENABLED=true

# point to VENV's local CUDA 11.8 python lib
export LD_LIBRARY_PATH=${PWD}/.venv/lib64/python3.11/site-packages/nvidia/cublas/lib:${PWD}/.venv/lib64/python3.11/site-packages/nvidia/cudnn/lib
```

</details>
<br/>

```bash
# Install FFMPEG locally
sudo apt install ffmpeg

# Setup Virtual Environment
make create-venv
source .venv/bin/activate
make requirements-dev

# OPTIONAL: for contributing and maintaining dependencies only
pip install pip-tools

# Clone Model
make fetch-model

# Start Model Backend
python main.py
```



### Run in Docker

<details>
<summary><b>GPU Variation</b></summary>
<br/>
The following additional flags must be added to the `docker run` command for GPU inferencing:

```bash
docker run --gpus all -e GPU_ENABLED=true -p 50051:50051 ghcr.io/defenseunicorns/leapfrogai/whisper:latest
```

</details>

#### Local Image Build and Run

For local image building and running.

```bash
docker build -t ghcr.io/defenseunicorns/leapfrogai/whisper:latest .
# add the "--gpus all" flag for CUDA inferencing
docker run -p 50051:50051 ghcr.io/defenseunicorns/leapfrogai/whisper:latest
```

#### Remote Image Build and Run

For pulling a tagged image from the main release repository.

Where `<IMAGE_TAG>` is the released packages found [here](https://github.com/orgs/defenseunicorns/packages/container/package/leapfrogai%2Fwhisper).

```bash
docker build -t ghcr.io/defenseunicorns/leapfrogai/whisper:<IMAGE_TAG> .
# add the "--gpus all" flag for CUDA inferencing
docker run -p 50051:50051 -d --name whisper ghcr.io/defenseunicorns/leapfrogai/whisper:<IMAGE_TAG>
```
