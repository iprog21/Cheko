class Manager < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  has_many :homeworks

  enum status: { inactive: 0, active: 1 }

  def name
    return "#{self.first_name} #{self.last_name}"
  end

  def create_agent
    uri = URI('http://172.104.186.240:3000/api/v1/accounts/1/agents')
    params = {
      name: self.name,
      email: self.email,
      role: "agent",
      availability_status: "available",
      auto_offline: true,
      "agent[name]" => self.name,
      "agent[email]" => self.email,
      "agent[role]" => "agent",
      "agent[availability_status]" => "available",
      "agent[auto_offline]" => true
    }   

    # "api_access_token" = "N7kvJH1xqrVgac3Yq5zkEZw4"
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.request_uri)
    req.set_form_data(params)
    req["api_access_token"] = "4E5F2zFPzMrpSbMZHMRAFHWL"
    res = http.request(req)
    result = JSON.parse(res.body)
    
    self.update(agent_id: result["id"])
  end

  def assign_inbox
    uri = URI('http://172.104.186.240:3000/api/v1/accounts/1/inbox_members')
    params = {
      inbox_id: 1,
      users_id: [
        self.agent_id
      ]
    }

    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.request_uri)
    req.set_form_data(params)
    req["api_access_token"] = "4E5F2zFPzMrpSbMZHMRAFHWL"
    res = http.request(req)
    result = JSON.parse(res.body)
    puts "\n\n #{result}\n\n"
  end

  def remove_agent
    uri = URI('http://172.104.186.240:3000/api/v1/accounts/1/agents')
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Delete.new(uri.request_uri)
    req["api_access_token"] = "4E5F2zFPzMrpSbMZHMRAFHWL"
    res = http.request(req)
  end
end
