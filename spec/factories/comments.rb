FactoryBot.define do
  factory :comment do
    user_id { "MyString" }
    body { "MyText" }
    post { nil }
  end
end
