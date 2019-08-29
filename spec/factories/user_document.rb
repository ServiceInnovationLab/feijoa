# frozen_string_literal: true

FactoryBot.define do
  factory :user_document do
    association :document, factory: :birth_record
    user
    audit_comment { AuditedOperationsService::ADD_BIRTH_RECORD_TO_USER }
  end
end
