class QnaJob < ApplicationJob
  queue_as :default

  def perform(type, tutor)
    if type == "new_qna"
      QnaMailer.new_qna(tutor).deliver_now
    end
  end
end
