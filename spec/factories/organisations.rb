# frozen_string_literal: true

FactoryBot.define do
  factory :organisation do
    name { Faker::Company.name }
    address { Faker::Address.street_address }
    email { Faker::Internet.email }
    contact_number { Faker::PhoneNumber.phone_number_with_country_code }
  end
end
