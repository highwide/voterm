FactoryGirl.define do
  factory :ballot do
    sequence(:name) { |n| "ユーザー#{n}" }
  end
end