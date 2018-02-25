class Result < ApplicationRecord
  belongs_to :vote
  has_one :winner, class_name: 'Candidacy', foreign_key: 'win_candidacy_id'

  def self.calc(vote_id)
    create!(
      vote_id: vote_id,
      win_candidacy_id: Round.calc_winner(IrvParameter.new(vote_id))
    )
  end

  def self.destroy_with_rounds(id)
    result = find(id)
    ActiveRecord::Base.transaction do
      Round.where(vote_id: result.vote_id).delete_all
      result.destroy
    end
  end
end