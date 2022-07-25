class Message < ApplicationRecord
  belongs_to :chat

  has_one_attached :document
end
