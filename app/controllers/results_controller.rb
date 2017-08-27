class ResultsController < ApplicationController
  before_action :set_result_and_rounds, only: :show

  def show
  end

  def create
    result = Result.calc(params.require(:vote_id))
    redirect_to action: :show, id: result.id
  end

  def destroy
    result = Result.destroy_with_rounds(params[:id])
    redirect_to "/votes/#{result.vote_id}"
  end

  private

  def set_result_and_rounds
    @result = Result.includes(vote: :rounds).find(params[:id])
  end
end