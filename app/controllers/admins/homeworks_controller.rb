class Admins::HomeworksController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_homework, except: [:index]

  def index
    @history = current_admin.role == "admin" ? Homework.where(status: "done", admin_id: current_admin.id).order(created_at: :asc) : Homework.where(status: "done").order(created_at: :asc)
    @pending = Homework.where(status: "reviewing", admin_id: current_admin.id)
    @ongoing = current_admin.role == "admin" ? Homework.where(status: "ongoing", admin_id: current_admin.id) : Homework.where(status: "ongoing")
    # @ongoing = Homework.find_by_sql("SELECT * FROM homeworks WHERE status IN(2,6) AND admin_id = #{current_admin.id}") 
    @finished_by_tutor = Homework.where(status: "finished_by_tutor", admin_id: current_admin.id)
  end

  def show
    @bids = Bid.where(homework_id: @homework.id).order(ammount: :asc)
    @tutor = @homework.documents.where(documentable_type: "Tutor")
    @qco = @homework.documents.where(documentable_type: "QualityOfficer")
    @admin = @homework.documents.where(documentable_type: "Admin")
  end

  def destroy
    @homework.destroy!
    redirect_to admins_homeworks_path, alert: "Homework successfully deleted"
  end

  def edit
    @leads = Admin.all
    @managers = Manager.all.not_deleted
    @tutors = Tutor.all
  end

  def update

    work = @homework.update(homework_params.to_h)
    
    if params[:homework][:internal_deadline].present?
      internal_deadline = DateTime.strptime(params[:homework][:internal_deadline], "%m/%d/%Y, %I:%M %p")
    else
      internal_deadline = DateTime.now - 1.day
    end
    @homework.update(internal_deadline: internal_deadline)

    if work && @homework.admin_id.present? && @homework.status == "reviewing"
      @homework.accept_order

      #send email all tutors that new homework is up for bidding
      tutors = Tutor.all 
      tutors.each do |tutor|
        NotifyTutorJob.set(wait: 2.seconds).perform_later("new_order", tutor, @homework)
      end
    end

    if params[:homework][:tutor_price].present?
      @homework.assign_tutor(nil, params[:homework][:tutor_price].to_i)
    end

    ActionCable.server.broadcast 'homework_update_channel', data: { homework: {
      id: @homework.id, 
      created_at: @homework.created_at.strftime("%b %d, %Y"), order_type: @homework.order_type.titleize, 
      sub_type: @homework.sub_type.present? ? @homework.sub_type.titleize : "", 
      deadline: @homework.deadline.present? ? @homework.deadline.strftime("%b %d, %Y - %l:%M %p"): "",  
      subject: @homework.subject.present? ? @homework.subject.titleize : "",
      tutor_category: @homework.tutor_category.present? ? @homework.tutor_category.titleize : "",
      words: @homework.words.present? ? @homework.words : "",
      tutor_samples: @homework.tutor_samples.present? ? @homework.tutor_samples.to_s.capitalize : "",
      tutor_skills: @homework.tutor_skills.present? ? @homework.tutor_skills.to_s.capitalize : "",
      view_bidders: @homework.view_bidders.present? ? @homework.view_bidders.to_s.capitalize : "",
      priority: @homework.priority.present? ? @homework.priority.to_s.capitalize : "",
      login_school: @homework.login_school.present? ? @homework.login_school.to_s.capitalize : "",
      admin_id: @homework.admin_id,
      admin: @homework.admin.name,
      name: @homework.name.present? ? @homework.name : "",
      order_type: @homework.order_type.titleize,
      internal_deadline_date: @homework.internal_deadline.present? ? @homework.internal_deadline.strftime("%B %d, %Y") : "",
      internal_deadline_time: @homework.internal_deadline.present? ? @homework.internal_deadline.strftime("%l:%M %p") : "",
      details: @homework.details.present? ? @homework.details : "",
      user: @homework.user.present? ? @homework.user.name : "",
      tutor: @homework.tutor.present? ? @homework.tutor.name : "",
      sub_tutor: @homework.sub_tutor.present? ? @homework.sub_tutor.name : "",
      hours_late: @homework.hours_late.present? ? @homework.hours_late : "",
      prof: @homework.prof.present? ? @homework.prof : "",
      grade: @homework.grade.present? ? @homework.grade : "",
      status: @homework.status.present? ? @homework.status : "",
      manager: @homework.manager.present? ? @homework.manager.name : "",
      tutor_price: @homework.tutor_price.present? ? @homework.tutor_price : "",
      price: @homework.price.present? ? @homework.price : "",
      profit: @homework.profit.present? ? @homework.profit : "",
      updates: @homework.updates.present? ? @homework.updates : "",
      sub_subject: @homework.sub_subject.present? ? @homework.sub_subject : "",
      file_received: @homework.file_received.present? ? @homework.file_received : "",
      notes: @homework.notes.present? ? @homework.notes : "",
      course: @homework.user.present? ? @homework.user.course : "",
      payment_received: @homework.payment_received.present? ? @homework.payment_received : "",
      } }, controller_action: "update"

    redirect_to admins_homeworks_path, notice: "Homework successfully updated"
  end

  def assign
    if @homework.internal_deadline.blank?
      internal_deadline = DateTime.now - 1.day
    end
   
    @homework.update(admin_id: current_admin.id, internal_deadline: internal_deadline)
    @homework.accept_order

    #send email all tutors that new homework is up for bidding
    tutors = Tutor.all 
    tutors.each do |tutor|
      NotifyTutorJob.set(wait: 2.seconds).perform_later("new_order", tutor, @homework)
    end

    redirect_to admins_homeworks_path #, notice: "Successfully assigned"
  end

  def assign_tutor
    bid = Bid.find(params[:bid_id])
    @homework.assign_tutor(bid)
    
    
    # if @homework.price.present? && @homework.tutor_price.present?
    #   @homework.calculate_profit
    # end
    if !@homework.name.present?
      name = "#{@homework.user.first_name[0,1].capitalize}#{@homework.user.last_name[0,1].capitalize}_#{@homework.subject}##{@homework.deadline.strftime("%b%m")}_#{@homework.tutor.first_name[0,1].capitalize}#{@homework.tutor.last_name[0,1].capitalize}"
      @homework.update(name: name)
    end
    
    tutor = Tutor.find(bid.tutor_id)
    NotifyTutorJob.set(wait: 2.seconds).perform_later("approved_bid", tutor, @homework)

    redirect_to admins_homeworks_path
  end

  def finish_homework
    @homework.finish_order
    HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "Finish")

    HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "ApprovedByManager")

    ActionCable.server.broadcast 'homework_update_channel', data: { homework: {
      id: @homework.id, 
      created_at: @homework.created_at.strftime("%b %d, %Y"), order_type: @homework.order_type.titleize, 
      sub_type: @homework.sub_type.present? ? @homework.sub_type.titleize : "", 
      deadline: @homework.deadline.present? ? @homework.deadline.strftime("%b %d, %Y - %l:%M %p"): "",  
      subject: @homework.subject.present? ? @homework.subject.titleize : "",
      tutor_category: @homework.tutor_category.present? ? @homework.tutor_category.titleize : "",
      words: @homework.words.present? ? @homework.words : "",
      tutor_samples: @homework.tutor_samples.present? ? @homework.tutor_samples.to_s.capitalize : "",
      tutor_skills: @homework.tutor_skills.present? ? @homework.tutor_skills.to_s.capitalize : "",
      view_bidders: @homework.view_bidders.present? ? @homework.view_bidders.to_s.capitalize : "",
      priority: @homework.priority.present? ? @homework.priority.to_s.capitalize : "",
      login_school: @homework.login_school.present? ? @homework.login_school.to_s.capitalize : "",
      admin_id: @homework.admin_id,
      admin: @homework.admin.name,
      name: @homework.name.present? ? @homework.name : "",
      order_type: @homework.order_type.titleize,
      internal_deadline_date: @homework.internal_deadline.present? ? @homework.internal_deadline.strftime("%B %d, %Y") : "",
      internal_deadline_time: @homework.internal_deadline.present? ? @homework.internal_deadline.strftime("%l:%M %p") : "",
      details: @homework.details.present? ? @homework.details : "",
      user: @homework.user.present? ? @homework.user.name : "",
      tutor: @homework.tutor.present? ? @homework.tutor.name : "",
      sub_tutor: @homework.sub_tutor.present? ? @homework.sub_tutor.name : "",
      hours_late: @homework.hours_late.present? ? @homework.hours_late : "",
      prof: @homework.prof.present? ? @homework.prof : "",
      grade: @homework.grade.present? ? @homework.grade : "",
      status: @homework.status.present? ? @homework.status : "",
      manager: @homework.manager.present? ? @homework.manager.name : "",
      tutor_price: @homework.tutor_price.present? ? @homework.tutor_price : "",
      price: @homework.price.present? ? @homework.price : "",
      profit: @homework.profit.present? ? @homework.profit : "",
      updates: @homework.updates.present? ? @homework.updates : "",
      sub_subject: @homework.sub_subject.present? ? @homework.sub_subject : "",
      file_received: @homework.file_received.present? ? @homework.file_received : "",
      notes: @homework.notes.present? ? @homework.notes : "",
      course: @homework.user.present? ? @homework.user.course : "",
      payment_received: @homework.payment_received.present? ? @homework.payment_received : "",
      } }, controller_action: "finish_homework"

    redirect_to admins_homeworks_path
  end

  def upload
    @homework.documents.create(file: params[:document][:file], documentable_id: current_admin.id, documentable_type: current_admin.class.name)
    HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "AdminUpload")
    redirect_to admins_homework_path(@homework.id)
  end

  private 

  def find_homework
    @homework = Homework.find(params[:id] || params[:homework_id])
  end

  def homework_params
    if params[:homework][:deadline].present?
      deadline = DateTime.strptime(params[:homework][:deadline], "%m/%d/%Y, %I:%M %p")
      params.require(:homework).permit(:admin_id, :manager_id, :tutor_id, :sub_tutor_id, :price, :additional, :internal_subject, :subject, :internal_deadline, :details, :priority, :tutor_price, :view_bidders, :login_school, :tutor_samples, :tutor_skills, :name, :min_bid).merge(deadline: deadline)
    else
      params.require(:homework).permit(:admin_id, :manager_id, :tutor_id, :sub_tutor_id, :price, :additional, :internal_subject, :subject, :internal_deadline, :details, :priority, :tutor_price, :view_bidders, :login_school, :tutor_samples, :tutor_skills, :name, :min_bid)
    end
  end
end
