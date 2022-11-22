class QnaMailer < ApplicationMailer
  default from: 'admin@cheko.com'
  layout 'mailer'

  def notify_user
    @qna = params[:qna]
    mail(to: @qna.user.email, subject: "A Q and A is picked up by a tutor")
  end

  def new_qna(tutor)
    mail(to: tutor.email, subject: "New Question")
  end

end
