class Document < ApplicationRecord
  belongs_to :homework
  has_one_attached :file
  has_many :tags, dependent: :destroy
end
