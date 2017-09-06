class VotesController < ApplicationController
  def index
    @election = Election.includes(:candidates).find(params[:election_id])
    @votes = @election.votes
  end

  def show
    @vote = Vote
      .where(id: params[:id])
      .includes(:ballots, candidacies: :candidate).first
  end

  def new
    @election = Election.find(params[:election_id])
    @vote = @election.votes.build
    @candidacies = @vote.candidacies.build
  end

  def create
    election = Election.find(params.require(:election_id))
    vote = election.votes.build(vote_params)
    candidacies_params.each do |id|
      vote.candidacies << Candidacy.new(candidate_id: id)
    end
    if vote.save
      redirect_to "/elections/#{vote.election_id}/votes"
    else
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:title, :description)
  end

  # TODO: fields_for使ったときのstrong paramsもうちょっと修正できるはず
  def candidacies_params
    params
      .require(:candidacies)
      .map { |p| p.permit(:candidate_id).values }
      .flatten
      .reject {|p| p == '' }
  end
end
