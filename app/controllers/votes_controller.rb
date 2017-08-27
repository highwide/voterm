class VotesController < ApplicationController
  def index
    @votes = Vote.where(election_id: params[:election_id])
  end

  def show
    @vote = Vote
      .where(id: params[:id])
      .includes(:ballots, candidacies: :candidate).first
  end

  def new
    @election = Election.find(params[:election_id])
    @vote = @election.votes.build
  end

  def create
    election = Election.find(params.require(:election_id))
    vote = election.votes.build(vote_params)
    if vote.save
      redirect_to "/elections/#{vote.election_id}/votes"
    else
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:title, :description)
  end
end
