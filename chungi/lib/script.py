import os
import uuid

from elevenlabs import VoiceSettings, play
from elevenlabs.client import ElevenLabs

ELEVENLABS_API_KEY="sk_bfc24b20358532f842db22c6ac572e26c4f016a5e46d6648"


client = ElevenLabs(
    api_key=ELEVENLABS_API_KEY
)

def text_to_speech_file(text: str) -> str:

    #use charlotte voice id, and input settings for the voice
    response = client.text_to_speech.convert(
        voice_id="XB0fDUnXU5powFXDhCwa",
        output_format="mp3_22050_32",
        text=text,
        model_id="eleven_turbo_v2",
    )

    #output MP3 file
    save_file_path = f"{uuid.uuid4()}.mp3"

    #write audio to a file
    with open(save_file_path, "wb") as f:
        for chunk in response:
            if chunk:
                f.write(chunk)

    print(f"{save_file_path}: A new audio file was saved successfully!")

    # Return the path of the saved audio file
    return save_file_path

text_to_speech_file("In the ancient land of Eldoria, where the skies were painted with shades of mystic hues and the forests whispered secrets of old, there existed a dragon named Zephyros. Unlike the fearsome tales of dragons that plagued human hearts with terror, Zephyros was a creature of wonder and wisdom, revered by all who knew of his existence.")