# frozen_string_literal: true

FactoryBot.define do
  factory :birth_record do
    sequence(:first_and_middle_names) { |n| "#{Faker::Name.first_name} #{n}" }
    family_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.birthday(18, 65) }
    place_of_birth { Faker::Address.city }
    sex { Faker::Gender.type }
    parent_first_and_middle_names { Faker::Name.first_name }
    parent_family_name { Faker::Name.last_name }
    other_parent_first_and_middle_names { Faker::Name.first_name }
    other_parent_family_name { Faker::Name.last_name }
  end
end
