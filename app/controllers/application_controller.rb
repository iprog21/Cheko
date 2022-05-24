class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  def after_sign_in_path_for(resource)
    if resource.class == Admin
      stored_location_for(resource) || admins_path
    else
      root_path
    end
  end

  def after_sign_out_path_for(resource)
    if resource == :admin
      new_admin_session_path
    elsif resource == :sponsor
      new_sponsor_session_path
    elsif resource == :sales_rep
      new_sales_rep_session_path
    else
      root_path
    end
  end

  def authenticate_admin!
    if admin_signed_in?
      super
    else
      redirect_to new_admin_session_path, :alert => 'You must login to continue'
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:logo])
  end
end
