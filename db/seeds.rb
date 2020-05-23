# frozen_string_literal: true

puts "\n== Delete User Table =="
User.delete_all

puts "\n== Create User Seed data =="
num = 100_000

list = []
num.times do |_i|
  user = {
    name: Faker::Name.name,
    email: Faker::Internet.email,
    address: Faker::Address.full_address
  }
  list << user
  if list.size >= 10_000
    User.import(list)
    list = []
  end
end
User.import(list)
