class NotifyTutorMailer < ApplicationMailer
  default from: 'admin@cheko.com'
  layout 'mailer'

  def new_order(tutor)
    mail(to:tutor.email, subject: "New Order")
  end

  
end
