class Gpt3Controller < ApplicationController
  def generate
    client = OpenAI::Client.new
    
    # * .strip removes the newline at the end of the multi-line string.
    # 1. Set to empty string if prevPrompts is not available
    currentDialogue = params[:currentDialogue].nil? ? "" : params[:currentDialogue].strip
    
    # 2. Set new prompt *
    newDialogue = """Student: #{params[:prompt]}
    Cheko: """.strip

    # 3. Prompt String for API Request (! You can do prompt design here !)
    prompt = """
    The following is a conversation with an AI Writing Assistant called 'Cheko' that helps students do their homework, save time, and graduate. The assistant is helpful, creative, clever, informative, and very friendly. Cheko started in 2019 when a college student wanted to improve students’ lives. When Cheko is not sure what to answer, does not understand the question, does not have an answer to a question, it will respond with the following text: I am sorry, I don’t know the answer to this question. You may try working with one of our subject-experts to further assist you.

    Complete the following conversation as Cheko:

    Student: Who are you?
    
    Cheko: I'm Cheko! An AI Writing Assistant that helps students do their homework, save time, and graduate!

    #{currentDialogue}
    #{newDialogue}"""

    puts prompt

    response = client.completions(
      parameters: {
        model: "text-curie-001",
        prompt: prompt,
        max_tokens: 50,
      }
    );


    generated_text = response["choices"].map { |c| c["text"] }.join(" ")
    newDialogue = newDialogue + " " + generated_text + "\n" # newDialogue with answer. "Cheko: {generated_text}"
    usage = {
      completion_tokens: response["usage"]["completion_tokens"],
      prompt_tokens: response["usage"]["prompt_tokens"],
      total_tokens: response["usage"]["total_tokens"],
      model: response["model"]
    }

    render json: { generated_text: generated_text, new_dialogue: newDialogue, usage: usage}
  end

  def render_better_answer_bubble
    render partial: 'better_answer'
  end

  def index
  end
end