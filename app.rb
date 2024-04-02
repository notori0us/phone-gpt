require 'openai'

secret_key = File.read('./api-key.txt').chomp

@client = OpenAI::Client.new(
  access_token: secret_key,
  request_timeout: 10
) do |f|
  #f.response :logger, Logger.new($stdout), bodies: true
end

#pp OpenAI.rough_token_count("Hello, this is dog, I have no idea what I'm doing")

def chat(message)
  response = @client.chat(
    parameters: {
      model: "gpt-3.5-turbo", # Required.
        messages: [{ role: "user", content: message}], # Required.
        temperature: 0.7,
    })

  response.dig("choices", 0, "message", "content")
end

def transcribe(audio_file)
  response = @client.audio.transcribe(
    parameters: { model: 'whisper-1',
                  file: File.open(audio_file, 'rb')
    })

  response.dig('text')
end

def speak(message)
  response = @client.audio.speech(
    parameters:{ 
      model: 'tts-1',
      input: message,
      voice: 'alloy' # one of alloy, echo, fable, onyx, nova, and shimmer
    })
end

#question = transcribe('./how_many_days.m4a')
#response = chat(question)
#File.binwrite('./response.mp3', speak(response))
