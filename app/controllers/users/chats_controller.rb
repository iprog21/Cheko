class Users::ChatsController < Users::UserAppController
  before_action :authenticate_user!
  
  def index
  end
end
