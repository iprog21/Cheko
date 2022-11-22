class HomeworkMailer < ApplicationMailer
  default from: 'admin@cheko.com'

  def notify_admin
    @homework = params[:homework]
    mail(to: "bret.encienzo.28@gmail.com", subject: 'New Order')
  end

  def notify_user
    @homework = params[:homework]
    mail(to: @homework.user.email, subject: 'Tutor has uploaded')
  end

  def finish_notify
    @homework = params[:homework]
    mail(to: @homework.user.email, subject: 'Order has been completed')
  end

  def notify_tm
    @homework = params[:homework]
    mail(to: @homework.manager.email, subject: 'An order has been assigned to you')
  end

  def notify_tutor
    @homework = params[:homework]
    mail(to: @homework.tutor.email, subject: 'An order has been assigned to you')
  end

end
