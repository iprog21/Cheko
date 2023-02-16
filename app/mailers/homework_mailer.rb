class HomeworkMailer < ApplicationMailer
  default from: 'admin@cheko.com'

  def notify_admin
    @homework = params[:homework]
    mail(to: "daveuygongco@gmail.com", subject: "HW-Help Order #{@homework.id}")
  end

  def notify_user
    @homework = params[:homework]
    mail(to: @homework.user.email, subject: 'Tutor has uploaded')
  end

  def finish_notify
    @homework = params[:homework]
    mail(to: @homework.user.email, subject: "HW-Help Order #{@homework.id} - Completed")
  end

  def notify_tm
    @homework = params[:homework]
    mail(to: @homework.manager.email, subject: 'An order has been assigned to you')
  end

  def notify_tutor
    @homework = params[:homework]
    mail(to: @homework.tutor.email, subject: 'An order has been assigned to you')
  end

  def admin_notify
    @homework = params[:homework]
    mail(to: @homework.admin.email, subject: "HW-Help Order #{@homework.id} - Task Submitted" )
  end
  
  def homework_notify_tm
    @homework = params[:homework]
    mail(to: @homework.manager.email, subject: "HW-Help Order #{@homework.id} - Task Submitted")
  end

  def new_order(admin)
    @homework = params[:homework]
    @admin = admin
    mail(to: @admin.email, subject: "HW-Help Order #{@homework.id}")
  end

  def tutor_bid(admin)
    @homework = params[:homework]
    @admin = admin
    mail(to: @admin.email, subject: "HW-Help Order #{@homework.id} - Bid")
  end

  def booked_order
    @homework = params[:homework]
    mail(to: @homework.user.email, subject: "HW-Help Order #{@homework.id} - Processing")
  end
end
