ARG ARCH=amd64

FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-dev-${ARCH} as builder

WORKDIR /leapfrogai

COPY requirements.txt .

RUN pip install -r requirements.txt

RUN /home/nonroot/.local/bin/ct2-transformers-converter --model openai/whisper-base --output_dir .model --copy_files tokenizer.json --quantization float32

# Use ffmpeg image to get compiled binaries
FROM cgr.dev/chainguard/ffmpeg:latest as ffmpeg

FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-${ARCH}

WORKDIR /leapfrogai

COPY --from=ffmpeg /usr/bin/ffmpeg /usr/bin
COPY --from=ffmpeg /usr/bin/ffprobe /usr/bin
COPY --from=ffmpeg /usr/lib/lib* /usr/lib
COPY --from=builder /home/nonroot/.local/lib/python3.11/site-packages /home/nonroot/.local/lib/python3.11/site-packages
COPY --from=builder /leapfrogai/.model/ /leapfrogai/.model/

COPY main.py .

EXPOSE 50051

ENTRYPOINT ["python", "-u", "main.py"]
