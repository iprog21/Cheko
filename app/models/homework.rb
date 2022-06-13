class Homework < ApplicationRecord
  include HTTParty
  
  belongs_to :user
  belongs_to :tutor, optional: true
  belongs_to :sub_tutor, class_name: "Tutor", optional: true
  belongs_to :manager, optional: true
  belongs_to :admin, optional: :true
  # belongs_to :subject

  has_many :documents, dependent: :destroy
  has_many :bids, dependent: :destroy

  enum order_type:     { essay: 0, thesis: 1, art: 2, group_project: 3, law: 4, math: 5, science: 6, translation: 7, code: 8 }
  enum payment_type:   { gcash: 0, bank: 1 }
  enum payment_status: { unpaid: 0, paid: 1 }
  enum status:         { reviewing: 0, cancel: 1, ongoing: 2, done: 3 }
  enum grade:          { a: 0, b: 1, c: 2 }
  enum tutor_category: { a_plus: 0, cheko: 1, standard: 2 }

  def accept_order
    # logger.info "\n \n #{self.name}"
    self.status = "ongoing"
    self.name = "#{self.user.first_name[0,1].capitalize}#{self.user.last_name[0,1].capitalize}_#{self.subject}##{self.deadline.strftime("%b%m")}_#{self.admin.first_name[0,1].capitalize}#{self.admin.last_name[0,1].capitalize}"
    self.save
  end

  def finish_order
    self.status = "done"
    self.save
  end

  def approve_payment
    self.payment_status = "paid"
    self.save
  end

  def assign_tutor(bid, price_given=nil)
    logger.info "\n\n #{price_given}\n\n"
    price = price_given.nil? ? bid.ammount : price_given
    # bid = Bid.find_by(homework_id: self.id, tutor_id: tutor_id)
    self.tutor_id.present? ? self.update!(tutor_price: price) : self.update!(tutor_id: bid.tutor_id, tutor_price: price)
    # self.tutor_id = tutor_id
    # self.tutor_price = bid.ammount
    # self.save
  end
end
