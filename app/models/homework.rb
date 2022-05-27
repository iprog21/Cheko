class Homework < ApplicationRecord
  belongs_to :user
  belongs_to :tutor, optional: true
  belongs_to :manager, optional: true

  enum status: { adjustment: 0, looking_tutor: 1, ongoing: 2, freeze: 3, done: 4 }
end
