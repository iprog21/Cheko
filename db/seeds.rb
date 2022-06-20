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
if Subject.all.count == 0
  subjects.each do |subj|
    Subject.create!(subj)
  end
end
puts "\n --- subjects okay desuwa ---\n"

puts "\n --- creating schools desuwa --- \n"
schools = [
  {name: "UPD"},
  {name: "DLSU"},
  {name: "CSB"},
  {name: "ADMU"},
  {name: "UA&P"},
  {name: "Enderun"}
]

if School.all.count == 0
  schools.each do |school|
    School.create!(school)
  end
end
puts "\n --- schools okay desuwa --- \n"