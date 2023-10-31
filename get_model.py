import whisper
import logging

MODEL_NAME = "base"
MODEL_DOWNLOAD_ROOT = ".model"

def main():
    model = whisper.load_model(name=MODEL_NAME, download_root=MODEL_DOWNLOAD_ROOT)
    logging.info("Model downloaded: %s/%s", MODEL_DOWNLOAD_ROOT, MODEL_NAME)

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    main()