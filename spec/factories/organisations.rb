# frozen_string_literal: true

FactoryBot.define do
  factory :organisation do
    name { Faker::Company.name }
  end
end
