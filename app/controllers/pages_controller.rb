class PagesController < ApplicationController
  def home
  end

  def pick_type
  end

  def new
    @homework = Homework.new
    @user = User.new
  end

  def professors
  end

  def about_us
  end

  def testimonials
  end

  def services
  end

  def how_it_works
  end

  def contact_us
    @contact = Contact.new
  end

  def check_email
    check = User.find_by(email: params[:user][:email])
    render :plain => check.present?
  end

  def professor_show
    @professor = Professor.find(params[:id])
    @reviews = @professor.prof_reviews.where(status: "approved")
  end
end
