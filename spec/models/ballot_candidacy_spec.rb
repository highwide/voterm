require 'rails_helper'

RSpec.describe BallotCandidacy, type: :model do
  let(:election) { create(:election, :with_vote_and_4candidacies) }
  let(:vote) { election.votes.first }
  let(:candidacy_ids) { vote.candidacies.pluck(:id) }

  describe 'to_calc_params' do
    subject { BallotCandidacy.to_calc_params(vote.id) }
    let(:ballot_ids) { create_list(:ballot, 3, vote_id: vote.id).map(&:id) }
    let(:expected_ary) do
      [
        [candidacy_ids[0], candidacy_ids[1], candidacy_ids[2], candidacy_ids[3]],
        [candidacy_ids[1], candidacy_ids[2], candidacy_ids[3], candidacy_ids[0]],
        [candidacy_ids[2], candidacy_ids[3], candidacy_ids[0], candidacy_ids[1]],
      ]
    end

    before(:each) do
      create(:ballot_candidacy, ballot_id: ballot_ids[0], candidacy_id: candidacy_ids[0], rank: 1)
      create(:ballot_candidacy, ballot_id: ballot_ids[0], candidacy_id: candidacy_ids[1], rank: 2)
      create(:ballot_candidacy, ballot_id: ballot_ids[0], candidacy_id: candidacy_ids[2], rank: 3)
      create(:ballot_candidacy, ballot_id: ballot_ids[0], candidacy_id: candidacy_ids[3], rank: 4)

      create(:ballot_candidacy, ballot_id: ballot_ids[1], candidacy_id: candidacy_ids[1], rank: 1)
      create(:ballot_candidacy, ballot_id: ballot_ids[1], candidacy_id: candidacy_ids[2], rank: 2)
      create(:ballot_candidacy, ballot_id: ballot_ids[1], candidacy_id: candidacy_ids[3], rank: 3)
      create(:ballot_candidacy, ballot_id: ballot_ids[1], candidacy_id: candidacy_ids[0], rank: 4)

      create(:ballot_candidacy, ballot_id: ballot_ids[2], candidacy_id: candidacy_ids[2], rank: 1)
      create(:ballot_candidacy, ballot_id: ballot_ids[2], candidacy_id: candidacy_ids[3], rank: 2)
      create(:ballot_candidacy, ballot_id: ballot_ids[2], candidacy_id: candidacy_ids[0], rank: 3)
      create(:ballot_candidacy, ballot_id: ballot_ids[2], candidacy_id: candidacy_ids[1], rank: 4)
    end

    it '同一vote_idの票をrank順にcandidacy_idを並べたballotごとの二重配列になる' do
      is_expected.to eq expected_ary
    end
  end
end
