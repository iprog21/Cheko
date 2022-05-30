class Tutor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :bids, dependent: :destroy

  enum status: { pending: 0, active: 1 }

  def name
    return "#{self.first_name} #{self.last_name}"
  end
end
