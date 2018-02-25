require 'rails_helper'

RSpec.describe BallotCandidacy, type: :model do
  let(:election) { create(:election, :with_vote_and_4candidacies) }
  let(:vote) { election.votes.first }
  let!(:ballot) { create(:ballot, :with_ballot_candidacies, vote: vote) }

  describe 'by_vote_id' do
    subject { BallotCandidacy.by_vote_id(vote.id) }
    it { expect(subject.sort).to eq ballot.ballot_candidacies.sort }
  end
end
