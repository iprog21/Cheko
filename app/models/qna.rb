class Qna < ApplicationRecord
  # belongs_to :user
  belongs_to :tutor, optional: true

  has_one :chat

  has_one_attached :document

  enum status:         {pending: 0, assigned: 1, done: 2}
  enum qna_type:       {essay: 0, art: 2, group_project: 3, law: 4, math: 5, science: 6, translation: 7, code: 8, economics: 9 }

  after_create :create_auth

  def create_auth
    hex = SecureRandom.hex

    self.auth = hex
    self.save
  end
end
