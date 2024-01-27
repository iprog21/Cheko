class Conversation < ApplicationRecord
  belongs_to :user, optional: true

  has_many :conversation_relateds
  has_many :conversation_sources
end
