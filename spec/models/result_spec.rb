require 'rails_helper'

RSpec.describe Result, type: :model do
  describe 'calc' do
    let(:election) { create(:election, :with_vote_and_4candidacies) }
    let(:vote) { election.votes.first }

    before(:each) { create(:ballot, :with_ballot_candidacies, vote: vote) }

    it { expect{ Result.calc(vote.id) }.to change{ Result.count }.by(1) }
  end
end
