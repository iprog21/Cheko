class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :validatable

  enum role: { super_admin: 0, admin: 1 }
  def name
    return "#{self.first_name} #{self.last_name}"
  end
end
