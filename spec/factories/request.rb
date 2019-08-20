# frozen_string_literal: true

FactoryBot.define do
  factory :request do
    association :requestee, factory: :user
    association :requester, factory: :organisation
    share_id { nil }
    document_type { 'birth_record' }
    note { 'Please share the birth record of Hemi' }
  end
end
