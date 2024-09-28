from elevenlabs import ElevenLabs, VoiceSettings

client = ElevenLabs(
    api_key="sk_bfc24b20358532f842db22c6ac572e26c4f016a5e46d6648",
)

client.text_to_speech.convert(
    voice_id="XB0fDUnXU5powFXDhCwa",
    optimize_streaming_latency="0",
    output_format="mp3_22050_32",
    text="It sure does, Jackie… My mama always said: “In Carolina, the air's so thick you can wear it!”",
    voice_settings=VoiceSettings(
        stability=0.1,
        similarity_boost=0.3,
        style=0.2,
    ),
)

