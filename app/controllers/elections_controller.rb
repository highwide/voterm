class ElectionsController < ApplicationController
  def index
    @elections = Election.all
  end

  def new
    @election = Election.new
  end

  def create
    election = Election.new(election_params)
    if election.save
      redirect_to action: 'index'
    else
    end
  end

  private

  def election_params
    params.require(:election).permit(:title, :description)
  end
end
