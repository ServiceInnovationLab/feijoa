# frozen_string_literal: true

FactoryBot.define do
  factory :share do
    birth_record
    user
    for_organisation_user

    trait :for_organisation_user do
      association :recipient, factory: :organisation_user
    end

    trait :revoked do
      association :revoker, factory: :user
      revoked_at { Time.now.utc }
    end
  end
end
