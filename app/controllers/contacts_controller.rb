class ContactsController < ApplicationController
  def create
    Contact.create(contact_params)
    redirect_to root_path
  end

  private

  def contact_params
    params.require(:contact).permit(:full_name, :email, :phone_number, :message)
  end
end
