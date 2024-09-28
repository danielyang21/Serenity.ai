import os
import uuid
from elevenlabs import VoiceSettings
from elevenlabs.client import ElevenLabs

from flask import Flask, request, jsonify


ELEVENLABS_API_KEY="sk_bfc24b20358532f842db22c6ac572e26c4f016a5e46d6648"

client = ElevenLabs(
    api_key=ELEVENLABS_API_KEY
)

#save given text to an mp3 file
def text_to_speech_file(text: str) -> str:

    voice_settings = VoiceSettings(
        stability=1.0,
        similarity_boost=1.0
    )

    #use charlotte voice id, and input settings for the voice
    response = client.text_to_speech.convert(
        voice_id="XB0fDUnXU5powFXDhCwa",
        output_format="mp3_22050_32",
        text=text,
        model_id="eleven_turbo_v2",
        voice_settings=voice_settings,
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


#allow for an api endpoint
app = Flask(__name__)

@app.route("/api/process", methods = ["POST"])

def process_data():
    data = request.get_json() #get the input as json
    
    if 'text' not in data:
        return jsonify({"error": "Missing 'text' field in the request"}), 400
    
    text = data['text']

    result = text_to_speech_file(text) 

    return jsonify({"result": result})


if __name__ == "__main__":
    app.run(debug=True, host = '0.0.0.0')
#text_to_speech_file("This is........ a pause.")
#text_to_speech_file("Hello, my name is Charlotte, nice to meet you")