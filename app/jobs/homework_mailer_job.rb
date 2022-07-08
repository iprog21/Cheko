class HomeworkMailerJob < ApplicationJob
  queue_as :default

  def perform(homework, type)
    @homework = homework
    if type == "Admin"
      HomeworkMailer.with(homework: @homework).notify_admin.deliver_now
    elsif type == "User"
      HomeworkMailer.with(homework: @homework).notify_user.deliver_now
    elsif type == "Finish"
      HomeworkMailer.with(homework: @homework).finish_notify.deliver_now
    end
  end
end
