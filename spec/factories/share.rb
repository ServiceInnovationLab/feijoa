# frozen_string_literal: true

FactoryBot.define do
  factory :share do
    birth_record
    user
    audit_comment { AuditedOperationsService::SHARE_BIRTH_RECORD }
    for_organisation

    trait :for_organisation do
      association :recipient, factory: :organisation
    end

    trait :revoked do
      after(:create) do |share, _evaluator|
        AuditedOperationsService.revoke_share(user: share.user, share: share)
      end
    end
  end
end
