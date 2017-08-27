FactoryGirl.define do
  factory :election do
    sequence(:title) { |n| "勉強会#{n}" }
    sequence(:description) { |n| "勉強会#{n}の説明" }

    trait :with_vote_and_4candidacies do
      after(:create) do |election|
        vote = create(:vote, election_id: election.id)
        4.times { create(:candidate, election_id: election.id) }
        election.candidates.each do |c|
          create(:candidacy, candidate_id: c.id, vote_id: vote.id)
        end
      end
    end
  end
end