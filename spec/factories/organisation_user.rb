# frozen_string_literal: true

FactoryBot.define do
  factory :organisation_user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(16, 16) }
    name { Faker::Company.name }
  end
end
