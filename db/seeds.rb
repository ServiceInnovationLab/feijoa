# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

FactoryBot.create_list :birth_record, 500
FactoryBot.create_list :organisation_user, 3

['brenda.wallace', 'ross.patel'].each do |person|
  email = "#{person}@dia.govt.nz"
  FactoryBot.create :admin_user, email: email unless AdminUser.find_by(email: email)
end
