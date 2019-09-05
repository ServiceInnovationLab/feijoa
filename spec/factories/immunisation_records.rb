# frozen_string_literal: true

FactoryBot.define do
  factory :immunisation_record do
    full_name { Faker::Name.name }
    nhi { 'ZZZ0016' }
    date_of_birth { '2018-02-03' }
  end
end
