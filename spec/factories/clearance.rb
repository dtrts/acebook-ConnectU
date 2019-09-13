# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "user#{n + 10}@example.com"
  end

  factory :user do
    email
    password { 'password' }
  end
end
