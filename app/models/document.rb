class Document < ApplicationRecord
  belongs_to :homework
  has_many :tags, dependent: :destroy
end
