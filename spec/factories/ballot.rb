FactoryGirl.define do
  factory :ballot do
    sequence(:name) { |n| "ユーザー#{n}" }

    trait :with_ballot_candidacies do
      after(:create) do |ballot|
        ballot.ballot_candidacies = []
        ballot.vote.candidacies.each_with_index do |c, i|
          ballot.ballot_candidacies << build(:ballot_candidacy, candidacy: c, rank: i)
        end
        ballot.save
      end
    end
  end
end