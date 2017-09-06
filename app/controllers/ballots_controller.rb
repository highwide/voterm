class BallotsController < ApplicationController
  def new
    @vote = Vote.includes(candidacies: :candidate).find(params[:vote_id])
    @ballot = @vote.ballots.build
    @ballot.ballot_candidacies.build
  end

  def create
    @vote = Vote.includes(candidacies: :candidate).find(params[:vote_id])
    @ballot = @vote.ballots.build(ballot_params.merge(vote_id: params[:vote_id]))
    @ballot.ballot_candidacies = \
      ballot_candidacies_params[:sorted_candidacy_ids]
        .split(',')
        .map
        .with_index { |p, i| BallotCandidacy.new(candidacy_id: p, rank: i + 1) }
    if @ballot.save
      redirect_to(vote_path(params[:vote_id]), notice: '投票に成功しました')
    else
      flash.now[:notice] = '登録に失敗しました'
      render :new
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
