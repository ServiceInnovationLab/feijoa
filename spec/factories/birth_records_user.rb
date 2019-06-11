# frozen_string_literal: true

FactoryBot.define do
  factory :birth_records_user do
    birth_record
    user
  end
end
