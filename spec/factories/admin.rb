FactoryBot.define do
  factory :admin do
    email { Faker::Internet.email }
    password { Faker::Internet.password(16, 16) }
  end
end
