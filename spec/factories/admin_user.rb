# frozen_string_literal: true

FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 16, max_length: 16) }
  end
end
