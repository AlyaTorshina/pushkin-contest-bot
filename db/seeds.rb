# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
file = IO.read('bd67.json')
file = JSON.parse(file)
file.each do |item|
  sorted_line = item[0]
  line = item[1]
  SortedLine.create(sorted_line: sorted_line, line: line)
end

file = IO.read('poems-set.json')
file = JSON.parse(file)
file.each do |item|
  title = item[0]
  item[1].each do |line|
    a = line.tr(" ","")
    LineWithTitle.create(title: title, line: a)
  end
end

file = IO.read('bd2.json')
file = JSON.parse(file)
file.each do |item|
  question = item[2]
  answer = item[3]
  MissingWord.create(question: question, answer: answer)
end
