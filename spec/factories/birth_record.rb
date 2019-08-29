# frozen_string_literal: true

FactoryBot.define do
  factory :birth_record do
    first_and_middle_names do
      ["#{Faker::Name.first_name} #{Faker::Name.middle_name}",
      "#{Faker::Name.first_name}",
      "#{Faker::Name.first_name} #{Faker::Name.middle_name} #{Faker::Name.middle_name}"].sample
    end
    family_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.birthday(18, 65) }
    place_of_birth { Faker::Address.city }
    sex { Faker::Gender.type }
    parent_first_and_middle_names { Faker::Name.first_name }
    parent_family_name { Faker::Name.last_name }
    other_parent_first_and_middle_names { Faker::Name.first_name }
    other_parent_family_name { Faker::Name.last_name }
    trait :static_details do
      # Static details for tests that take screenshots with Percy
      first_and_middle_names { 'Timmy' }
      family_name { 'Target-Person' }
      date_of_birth { '1979-01-01' }
      place_of_birth { 'Wellington' }
      sex { 'X' }
      parent_first_and_middle_names { 'Daniel' }
      parent_family_name { 'Chuck' }
      other_parent_first_and_middle_names { 'Tameka' }
      other_parent_family_name { 'Senger' }
    end
  end
end
