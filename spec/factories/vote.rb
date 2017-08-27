FactoryGirl.define do
  factory :vote do
    sequence(:title) { |n| "第#{n}回テーマ決め" }
    sequence(:description) { |n| "第#{n}回" }
  end
end