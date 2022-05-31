# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

subjects = [
  {name: "English", status: 1},
  {name: "Physics", status: 1},
  {name: "Philosophy", status: 1},
  {name: "Math", status: 1},
]

puts "\n --- creating subjects desuwa --- \n"
subjects.each do |subj|
  Subject.create!(subj)
end
puts "\n --- subjects okay desuwa ---\n\n"