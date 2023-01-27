class Users::HomeworksController < Users::UserAppController
  before_action :authenticate_user!
  before_action :find_homework, except: [:index, :create, :new, :pick_type, :add_to_drafts]
  
  def index
    # @pending = current_user.homeworks.where(status: "reviewing")
    # @ongoing = current_user.homeworks.where(status: "ongoing")
    # @history = current_user.homeworks.where(status: "done")
    @homeworks = current_user.homeworks.not_deleted
  end

  def show
    @tutor = @homework.documents.where(documentable_type: "Tutor")
    @qco = @homework.documents.where(documentable_type: "QualityOfficer")
    @admin = @homework.documents.where(documentable_type: "Admin")
  end

  def new
    if params[:type].blank?
      redirect_to pick_type_users_homeworks_path
    else
      @homework = current_user.homeworks.new()
    end
  end

  def create
    @admin = Admin::where(status: 1).first
    @homework = current_user.homeworks.new(homework_params)

    if @homework.save
      #assign admin_id
      @homework.update(admin_id: @admin.id)

      HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "Admin")

      team_managers = Manager.all
      team_managers.each do |team_manager|
        NotifyTmMailerJob.set(wait: 2.seconds).perform_later("new_order", team_manager)
      end

      redirect_to users_homeworks_path
    else
      render 'new'
    end
  end

  def success
    unless @homework.user_id == current_user.id
      redirect_to users_homeworks_path
    end
  end

  def edit
  end

  def update
    if @homework.update!(homework_params)
      redirect_to users_homeworks_path
    else
      render 'edit'
    end
  end

  def destroy
  end

  def add_to_drafts
    @homework = current_user.homeworks.new(homework_params)
    if @homework.save
      @homework.update(status: "in_draft")
      redirect_to users_homeworks_path
    else
      redirect_to new_users_homework_path
    end
  end

  def submit_homework
    @admin = Admin::where(status: 1).first
    @homework = Homework.update(@homework.id, status: "reviewing", admin_id: @admin.id)

    HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "Admin")
    #send email all tutors that new homework is up for bidding
    tutors = Tutor.all 
    tutors.each do |tutor|
      NotifyTutorJob.set(wait: 2.seconds).perform_later("new_order", tutor)
    end

    redirect_to users_homeworks_path
  end

  def delete_draft
    @homework = Homework.find(params[:homework_id])
    @homework.soft_delete
    @homework.update(status: "deleted", deleted_at: DateTime.now)
    redirect_to users_homeworks_path
  end

  private 

  def find_homework
    @homework = Homework.find(params[:id] || params[:homework_id])
  end

  def homework_params
    if params[:homework][:deadline].blank?
      deadline = DateTime.now
    else
      deadline = DateTime.strptime(params[:homework][:deadline], "%m/%d/%Y, %I:%M %p")
    end
    params.require(:homework).permit(:details, :payment_type, :subject, :sub_subject, :budget, :tutor_skills, :tutor_samples, :sub_type, :priority, :view_bidders, :login_school, :budget, :order_type, :words, :tutor_category, :hw_attachment => []).merge(deadline: deadline)
  end
end
