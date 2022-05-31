class Homework < ApplicationRecord
  belongs_to :user
  belongs_to :tutor, optional: true
  belongs_to :manager, optional: true
  belongs_to :admin, optional: :true
  belongs_to :subject

  has_many :documents, dependent: :destroy
  has_many :bids, dependent: :destroy

  enum payment_type:   { gcash: 0, bank: 1 }
  enum payment_status: { unpaid: 0, paid: 1 }
  enum status:         { reviewing: 0, looking_tutor: 1, ongoing: 2, done: 3 }
  enum grade:         { a: 0, b: 1, c: 2 }

  def finalize_name
    self.name = "#{self.tutor.first_name[0,1].capitalize}#{self.tutor.last_name[0,1].capitalize}_#{self.subject.name}##{self.deadline.strftime("%b%m")}_#{self.admin.first_name[0,1].capitalize}#{self.admin.first_name[0,1].capitalize}"
    self.save
  end
end
