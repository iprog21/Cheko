class Homework < ApplicationRecord
  belongs_to :user
  belongs_to :tutor, optional: true
  belongs_to :manager, optional: true
end
