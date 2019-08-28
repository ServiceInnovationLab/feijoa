# frozen_string_literal: true

FactoryBot.define do
  factory :organisation_member do
    user
    organisation
    role { 'staff' }
  end
end
