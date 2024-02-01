class Undetectable
  def self.api_key
    "1700976779934x378118977479095900"
  end

  def self.undetectable_url
    "https://api.undetectable.ai"
  end

  def self.humanize(content)
    url = undetectable_url + '/submit'
    conn = Faraday.new(
      url: url,
      headers: {
        'Content-Type' => 'application/json',
        'api-key' => api_key
      }
    )
    response = conn.post() do |req|
      req.body = {
        "content": content,
        "readability": "High School",
        "purpose": "General Writing",
        "strength": "More Human"
      }.to_json
    end

    response_json = JSON.parse(response.body)
    response_json
  end
end