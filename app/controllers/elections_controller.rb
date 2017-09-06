class ElectionsController < ApplicationController
  def index
    @elections = Election.all
  end

  def new
    @election = Election.new
  end

  def create
    @election = Election.new(election_params)
    if @election.save
      redirect_to(election_votes_path(@election.id), notice: '選挙を編集しました')  
    else
      flash.now[:notice] = '登録に失敗しました'
      render :new
    end
  end

  def edit
    @election = Election.find(params[:id])
  end

  def update
    @election = Election.find(params[:id])
  
    if @election.update_attributes(election_params)
      redirect_to(election_votes_path(@election.id), notice: '選挙を編集しました')   
    else
      flash.now[:notice] = '登録に失敗しました'
      render :edit
    end
  end

  private

  def election_params
    params.require(:election).permit(
      :title,
      :description,
      candidates_attributes: [:id, :title, :_destroy]
    )
  end
end
