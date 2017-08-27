FactoryGirl.define do
  factory :candidate do
    sequence(:title) { |n| "候補#{n}" }
    sequence(:description) { |n| "候補#{n}の説明" }
  end
end