# frozen_string_literal: true

FactoryBot.define do
  factory :birth_records_user do
    birth_record
    user
    audit_comment { AuditedOperationsService::ADD_BIRTH_RECORD_TO_USER }
  end
end
