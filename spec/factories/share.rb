# frozen_string_literal: true

FactoryBot.define do
  factory :share do
    birth_record
    user
    audit_comment { AuditedOperationsService::SHARE_BIRTH_RECORD }
    for_organisation_user

    trait :for_organisation_user do
      association :recipient, factory: :organisation_user
    end
  end
end
