class QualityOfficer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :validatable
  # :registerable, :recoverable, :rememberable, 

  def name
    return "#{self.first_name} #{self.last_name}"
  end
end
