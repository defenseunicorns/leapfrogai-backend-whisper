import logging
import os
import tempfile
from typing import Iterator
import asyncio

import leapfrogai

from faster_whisper import WhisperModel

logger = logging.getLogger(__name__)

model_path = ".model"

GPU_ENABLED = (
    False if os.environ.get("GPU_ENABLED", "False").lower() != "true" else True
)


def make_transcribe_request(filename, task, language, temperature, prompt):
    device = "cuda" if GPU_ENABLED else "cpu"
    model = WhisperModel(model_path, device=device, compute_type="float32")

    segments, info = model.transcribe(filename, beam_size=5)

    output = ""

    for segment in segments:
        output += segment.text

    logger.info("Completed " + filename)
    logger.info(output)

    return {"text": output}


def call_whisper(
    request_iterator: Iterator[leapfrogai.AudioRequest], task: str
) -> leapfrogai.AudioResponse:
    data = bytearray()
    prompt = ""
    temperature = 0.0
    inputLanguage = "en"

    for request in request_iterator:
        if (
            request.metadata.prompt
            and request.metadata.temperature
            and request.metadata.inputlanguage
        ):
            prompt = request.metadata.prompt
            temperature = request.metadata.temperature
            inputLanguage = request.metadata.inputlanguage
            audioFormat = request.metadata.format
            continue

        data.extend(request.chunk_data)

    with tempfile.NamedTemporaryFile("wb") as f:
        f.write(data)
        result = make_transcribe_request(
            f.name, task, inputLanguage, temperature, prompt
        )
        text = str(result["text"])
        logger.info("Transcription complete!")
        return leapfrogai.AudioResponse(text=text)


class Whisper(leapfrogai.AudioServicer):
    def Translate(
        self,
        request_iterator: Iterator[leapfrogai.AudioRequest],
        context: leapfrogai.GrpcContext,
    ):
        return call_whisper(request_iterator, "translate")

    def Transcribe(
        self,
        request_iterator: Iterator[leapfrogai.AudioRequest],
        context: leapfrogai.GrpcContext,
    ):
        return call_whisper(request_iterator, "transcribe")

    def Name(self, request, context):
        return leapfrogai.NameResponse(name="whisper")


async def main():
    logging.basicConfig(level=logging.INFO)
    logger.info(f"GPU_ENABLED = {GPU_ENABLED}")
    await leapfrogai.serve(Whisper())


if __name__ == "__main__":
    asyncio.run(main())
