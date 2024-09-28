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
#text_to_speech_file("To begin this mindfulness meditation, let yourself get into a comfortable position, whatever that looks like for you. When your body feels ready, gently close your eyes. With your eyes closed, take a moment to tune inward, simply noticing your body. Tune into the weight of gravity and the points of contact between you and the surface on which you are resting. What else do you notice? What is it like to be in your body right now? As you observe, simply accept and allow whatever you notice, harboring no judgment—just being mindful. Notice what is with a sense of compassion in your heart and let it be. Now, continue this mindfulness with your breath as well as your body. If you haven’t already, begin to tune into the sensations of breathing. What do you notice? Just observe, accept, and allow—no judgment, simply letting everything be as it is. Stay mindful of your breath and body with a sense of compassion in your heart. Keeping your eyes closed, allow your awareness to expand to include the space around your body. It’s as if you can sense the air around you, the objects around you. Just allow them to be, as you simply are. There’s nothing to do, nothing to judge. If your mind wanders, that’s okay. Don’t judge it; just return your focus to what is. Be connected to your breath, your body, and your sense of presence in the world around you. Let everything simply be, including yourself. Now, begin to let your attention travel back, becoming more and more aware of physical sensations. Roll your shoulders, wiggle your fingers and toes, still being mindful of what is. Take this present moment awareness with you as you slowly begin to open your eyes back to the world around you. Wonderful job doing this practice. We hope you enjoy the rest of your beautiful day.")
#text_to_speech_file("Hello, my name is Charlotte, nice to meet you")