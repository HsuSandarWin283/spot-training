const functions = require("firebase-functions");
const admin = require("firebase-admin");
const cors = require("cors")({ origin: true });

admin.initializeApp();

exports.textToSpeech = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") {
      return res.status(405).json({ error: "Method not allowed" });
    }

    try {
      const { text, languageCode } = req.body;

      if (!text || text.trim().isEmpty) {
        return res.status(400).json({ error: "Text is required" });
      }

      const lang = languageCode || "my-MM";
      console.log(`[TTS] Request: text="${text}", languageCode="${lang}"`);

      const textToSpeech = require("@google-cloud/text-to-speech");
      const client = new textToSpeech.TextToSpeechClient();

      const [voicesResponse] = await client.listVoices({ languageCode: lang });
      const availableVoices = voicesResponse.voices || [];

      console.log(`[TTS] Available ${lang} voices:`);
      availableVoices.forEach((v) => {
        console.log(`  - name: ${v.name}, languageCode: ${v.languageCodes}, ssmlGender: ${v.ssmlGender}`);
      });

      let voiceName;
      if (availableVoices.length > 0) {
        const neuralVoice = availableVoices.find(
          (v) => v.name.includes("Neural")
        );
        voiceName = neuralVoice
          ? neuralVoice.name
          : availableVoices[0].name;
      } else {
        voiceName = lang === "my-MM" ? "my-MM-Standard-A" : "en-US-Standard-C";
        console.log(`[TTS] No voices found for ${lang}, using fallback: ${voiceName}`);
      }

      console.log(`[TTS] Selected voice: ${voiceName}`);

      const [response] = await client.synthesizeSpeech({
        input: { text: text },
        voice: {
          languageCode: lang,
          name: voiceName,
          ssmlGender: "FEMALE",
        },
        audioConfig: {
          audioEncoding: "MP3",
          speakingRate: 0.9,
          pitch: 0.0,
          volumeGainDb: 0.0,
          sampleRateHertz: 24000,
        },
      });

      const audioBase64 = response.audioContent.toString("base64");

      console.log(`[TTS] Success: audio length=${audioBase64.length} chars, voice=${voiceName}`);

      return res.status(200).json({
        success: true,
        audioBase64: audioBase64,
        audioFormat: "mp3",
        languageCode: lang,
        voice: voiceName,
        availableVoices: availableVoices.map((v) => v.name),
      });
    } catch (error) {
      console.error("[TTS] Error:", error.message);
      return res.status(500).json({
        success: false,
        error: "Text-to-speech generation failed: " + error.message,
      });
    }
  });
});
