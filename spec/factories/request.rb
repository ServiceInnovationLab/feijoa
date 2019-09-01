# frozen_string_literal: true

FactoryBot.define do
  factory :request do
    association :requestee, factory: :user
    association :requester, factory: :organisation
    share_id { nil }
    document_type { 'BirthRecord' }
    note { 'Please share the birth record of Hemi' }
    trait :cancelled do
      after(:create) do |request, _evaluator|
        request.cancel!
      end
    end
    trait :declined do
      after(:create) do |request, _evaluator|
        request.decline!
      end
    end
    trait :received do
      after(:create) do |request, _evaluator|
        request.view!
      end
    end
    trait :resolved do
      after(:create) do |request, _evaluator|
        share = create(:share, user: request.requestee, recipient: request.requester)
        request.respond_with_share(share)
      end
    end
  end
end
