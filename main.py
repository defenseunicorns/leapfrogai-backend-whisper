import logging
import tempfile
from typing import Iterator
import asyncio

import whisper

import leapfrogai

from faster_whisper import WhisperModel

model_size = "base"


def make_transcribe_request(filename, task, language, temperature, prompt):
    model = WhisperModel(model_size, device="cpu", compute_type="float16")

    segments, info = model.transcribe(filename, beam_size=5)

    output = ""

    for segment in segments:
        output += segment.text

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
    whisper.load_model(name="base", download_root=".model")
    logging.basicConfig(level=logging.INFO)
    await leapfrogai.serve(Whisper())


if __name__ == "__main__":
    asyncio.run(main())
