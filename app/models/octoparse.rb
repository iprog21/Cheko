class Octoparse

  def self.search_task_id
    
  end

  def self.octoparse_url
    "https://openapi.octoparse.com"
  end

  def self.api_email_address
    "daveuygongco@gmail.com"
  end

  def self.api_password
    "77octo-ChekoAI"
  end

  def self.get_token
    url = octoparse_url + '/token'
    conn = Faraday.new(
      url: url,
      headers: {'Content-Type' => 'application/json'}
    )

    response = conn.post() do |req|
      req.body = {
        username: api_email_address,
        password: api_password,
        grant_type: "password"
      }.to_json
    end


    response_json = JSON.parse(response.body)

    return response_json['data']['access_token']
  end

  def self.change_text_search
    url = octoparse_url + '/token'
    conn = Faraday.new(
      url: url,
      headers: {'Content-Type' => 'application/json'}
    )

    response = conn.post() do |req|
      req.body = {
        username: api_email_address,
        password: api_password,
        grant_type: "password"
      }.to_json
    end


    response_json = JSON.parse(response.body)

    return response_json['data']['access_token']
  end

end