class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :homeworks, dependent: :destroy
  has_many :prof_reviews

  enum status: { inactive: 0, active: 1 }
  def name
    return "#{self.first_name} #{self.last_name}"
  end
end
