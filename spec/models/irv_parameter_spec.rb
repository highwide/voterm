require 'rails_helper'

RSpec.describe 'IrvParameter' do
  let(:election) { create(:election, :with_vote_and_4candidacies) }
  let(:vote) { election.votes.first }
  let(:param) { IrvParameter.new(vote.id) }
  let!(:ballot) { create(:ballot, :with_ballot_candidacies, vote: vote) }

  describe 'initialize' do
    it 'newしたときに必要なinstance変数が設定されている' do
      aggregate_failures do
        expect(param.vote_id).to eq vote.id
        expect(param.loser_id).to be_nil
      end
    end
  end

  xdescribe 'exist_majority?' do
    subject { param.exist_majority? }

    context '過半数があるとき' do
      it { is_expected.to be_truthy }
    end

    context '過半数がないとき' do
      it { is_expected.to be_falsy }
    end
  end

  xdescribe 'majority_id' do
    subject { param.majority_id }

    context 'majorityが確定しているとき' do
      it { is_expected.to eq majority }
    end

    context 'majorityが確定していないとき' do
      it { is_expected.to be_nil }
    end
  end
end
