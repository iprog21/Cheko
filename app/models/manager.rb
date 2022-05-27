class Manager < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  has_many :homeworks

  enum status: { inactive: 0, active: 1 }

  def name
    return "#{self.first_name} #{self.last_name}"
  end
end
