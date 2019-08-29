# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 16, max_length: 16) }
    trait :organisation_staff do
      after(:create) do |user|
        user.organisation_members = [create(:organisation_member, user: user)]
      end
    end
  end
end
