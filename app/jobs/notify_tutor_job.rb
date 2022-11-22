class NotifyTutorJob < ApplicationJob
  queue_as :default

  def perform(type, tutor)    
    if type == "new_order"
      NotifyTutorMailer.new_order(tutor).deliver_now
    end
  end

  
end
