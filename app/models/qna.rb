class Qna < ApplicationRecord
  belongs_to :user
  belongs_to :tutor, optional: true

  has_many :chats

  enum status: {pending: 0, assigned: 1, done: 2}
end
