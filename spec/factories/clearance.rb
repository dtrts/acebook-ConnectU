FactoryBot.define do
  sequence :email do |n|
    "user#{n + 10}@example.com"
  end

  sequence :username do |n|
    "user#{n + 1}"
  end

  factory :user do
    email
    password { "password" }
    username
  end
end
