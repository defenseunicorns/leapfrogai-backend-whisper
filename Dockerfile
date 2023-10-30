FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-dev-amd64 as builder

WORKDIR /leapfrogai

COPY requirements.txt .

RUN pip install -r requirements.txt --user

USER root
RUN mkdir -p .model
COPY .model/ .model/

FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-amd64

WORKDIR /leapfrogai

COPY --from=builder /home/nonroot/.local/lib/python3.11/site-packages /home/nonroot/.local/lib/python3.11/site-packages
COPY --from=builder /leapfrogai/.model/ /leapfrogai/.model/

COPY main.py .

EXPOSE 50051:50051

ENTRYPOINT ["python3", "main.py"]