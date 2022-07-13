class Users::ProfessorsController < Users::UserAppController
  before_action :authenticate_user!, except: [:search]
  
  def index
  end

  def show
    @professor = Professor.find(params[:id])
    @reviews = @professor.prof_reviews.where(status: "approved")
  end

  def new
    @professor = ProfReview.new
    @school = School.all
  end

  def create
    @professor = current_user.prof_reviews.create(professor_params)
    redirect_to users_professors_path
  end

  def search
    profs = Professor.where("LOWER(first_name) LIKE :search OR LOWER(last_name) LIKE :search", {search: "%#{params[:search].downcase}%"}).map{|prof| [prof.name, prof.id]}
    #.pluck(:first_name, :last_name)
    render json: {profs: profs}
  end

  private
  def professor_params
    params.require(:prof_review).permit(:first_name, :last_name, :school_id, :school_name, :easiness, :effectiveness, :life_changing, :light_workload, :leniency, :average, :a_able, :b_pls_able, :b_able, :c_able, :batch1_able, :batch2_able, :batch3_able, :batch4_able, :content, :subject)
  end
end
