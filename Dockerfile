FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-dev-amd64 as builder

WORKDIR /leapfrogai

COPY requirements.txt .

RUN pip install -r requirements.txt --user

COPY src/get_model.py .
RUN mkdir -p .model
RUN python3 get_model.py

# Use ffmpeg image to get compiled binaries
FROM cgr.dev/chainguard/ffmpeg:latest as ffmpeg

FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-amd64

WORKDIR /leapfrogai

COPY --from=ffmpeg /usr/bin/ffmpeg /usr/bin
COPY --from=ffmpeg /usr/bin/ffprobe /usr/bin
COPY --from=ffmpeg /usr/lib/lib* /usr/lib
COPY --from=builder /home/nonroot/.local/lib/python3.11/site-packages /home/nonroot/.local/lib/python3.11/site-packages
COPY --from=builder /leapfrogai/.model/ /leapfrogai/.model/

COPY main.py .

EXPOSE 50051

ENTRYPOINT ["python3", "-u", "main.py"]