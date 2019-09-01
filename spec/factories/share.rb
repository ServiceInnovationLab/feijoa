# frozen_string_literal: true

FactoryBot.define do
  factory :share do
    association :document, factory: :birth_record
    user
    audit_comment { Audit::SHARE_BIRTH_RECORD }
    for_organisation

    trait :for_organisation do
      association :recipient, factory: :organisation
    end

    trait :revoked do
      after(:create) do |share, _evaluator|
        share.revoke(revoked_by: share.user)
      end
    end
  end
end
