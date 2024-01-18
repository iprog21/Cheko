require 'uri'
require 'net/http'

class Gpt3Controller < ApplicationController

  def generate

    url = URI("https://api.perplexity.ai/chat/completions")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["accept"] = 'application/json'
    request["content-type"] = 'application/json'
    request["authorization"] = "Bearer #{ENV.fetch('PERPLEXITY_AI_TOKEN')}"

    client = OpenAI::Client.new

    # 1. Default
    initialDialogue = [
      { role: "system", content: "The following is a conversation with an AI Writing Assistant called 'Cheko' that helps students do their homework, save time, and graduate. The assistant is helpful, creative, clever, informative, and very friendly. Cheko started in 2019 when a college student wanted to improve students’ lives." },
      { role: "assistant", content: "Hello! I'm Cheko, an AI-powered writing assistant to help you finish your homework fast!"},
    ]
  
    # 2. Turn prompt into a message object
    prompt = {role: "user", content: params[:prompt]}

    # 3. Initialize/Extend currentDialogue
    currentDialogue = params[:currentDialogue].nil? ? initialDialogue.concat([prompt]) : params[:currentDialogue].concat([prompt])

    # 4. REQUEST via PERPLEXITY.AI API
    request.body = {:model => "mistral-7b-instruct", :messages => [prompt]}.to_json
    response = http.request(request)
    response = JSON.parse(response.body)

    # # 4. REQUEST via OpenAI API
    # response = client.chat(
    #   parameters: {
    #     model: "gpt-4-1106-preview",
    #     messages: currentDialogue,
    #   }
    # )

    # 5. Process OpenAI RESPONSE / PERLEXITY.AI RESPONSE
    generated_text = response.dig("choices", 0, "message", "content")
    puts response
    newDialogue = currentDialogue.concat([response.dig("choices", 0, "message")])

    usage = {
      completion_tokens: response.dig("usage", "completion_tokens"),
      prompt_tokens: response.dig("usage", "prompt_tokens"),
      total_tokens: response.dig("usage", "total_tokens"),
      model: response.dig("model")
    }

    render json: { generated_text: generated_text, new_dialogue: newDialogue, usage: usage}
  end

  def generate_v2
    max_retry = 10
    num_retry = 0
    before_start_task_count_num = Octoparse.get_non_exported_data[:data_size]

    begin
      Octoparse.start_task(params[:prompt])
      exported_data = Octoparse.get_non_exported_data
      puts "generated_text:: #{exported_data[:text]}"
      if exported_data[:data_size] > before_start_task_count_num
        render json: { generated_text: exported_data[:text]}
        return
      else
        raise StandardError.new("task is not finish")
      end
    rescue StandardError => e
      num_retry +=1
      if num_retry == max_retry
        render json: { generated_text: "Server Timeout error."}
        return
      end
      sleep 10
      retry
    end
  end

  def render_better_answer_bubble
    render partial: 'better_answer'
  end

  def index
  end
end
