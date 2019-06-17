FactoryBot.define do
  factory :user_share, class: User::Share do
    birth_record
    user
    for_organisation_user

    trait :for_organisation_user do
      association :recipient, factory: :organisation_user
    end
  end
end
