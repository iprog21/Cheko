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
    elsif type == "AssignToTM"
      HomeworkMailer.with(homework: @homework).notify_tm.deliver_now
    elsif type == "AssignToTutor"
      HomeworkMailer.with(homework: @homework).notify_tutor.deliver_now
    elsif type == "NotifyAdmin"
      HomeworkMailer.with(homework: @homework).admin_notify.deliver_now
    elsif type == "NotifyTM"
      HomeworkMailer.with(homework: @homework).homework_notify_tm.deliver_now
    elsif type == "BookedOrder"
      HomeworkMailer.with(homework: @homework).booked_order.deliver_now
    elsif type == "NewOrder"
      admins = Admin.all
      admins.each do |admin|
        HomeworkMailer.with(homework: @homework).new_order(admin).deliver_now
      end
    elsif type = "TutorBid"
      admins = Admin.where(role: 1, status: 1)
      admins.each do |admin|
        HomeworkMailer.with(homework: @homework).tutor_bid(admin).deliver_now
      end
    end
  end
end
