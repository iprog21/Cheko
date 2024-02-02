class AddUserInitialsToProfReview < ActiveRecord::Migration[6.0]
  def change
    add_column :prof_reviews, :user_initials, :string
  end
end
