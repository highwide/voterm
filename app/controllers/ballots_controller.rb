class BallotsController < ApplicationController
  def new
    @vote = Vote.find(params[:vote_id])
    @ballot = Ballot.new
    @ballot.ballot_candidacies.build
    @candidacies = Candidacy.where(vote_id: params[:vote_id]).includes(:candidate)
  end

  def create
    ballot = Ballot.new(ballot_params.merge(vote_id: params[:vote_id]))
    ballot.ballot_candidacies = \
      ballot_candidacies_params[:sorted_candidacy_ids]
        .split(',')
        .map
        .with_index { |p, i| BallotCandidacy.new(candidacy_id: p, rank: i + 1) }
    if ballot.save!
      redirect_to(vote_path(params[:vote_id]), notice: '投票に成功しました')
    else
      fail('投票に失敗しました')
    end
  end

  private

  def ballot_params
    params.require(:ballot).permit(:name)
  end

  def ballot_candidacies_params
    params.require(:ballot).permit(:sorted_candidacy_ids)
  end
end
