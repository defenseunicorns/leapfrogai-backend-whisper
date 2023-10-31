import whisper
import logging

MODEL_NAME = "base"
MODEL_DOWNLOAD_ROOT = ".model"


def main():
    whisper.load_model(name=MODEL_NAME, download_root=MODEL_DOWNLOAD_ROOT)
    logging.info(f"Model downloaded: {MODEL_DOWNLOAD_ROOT}/{MODEL_NAME}")


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    main()
