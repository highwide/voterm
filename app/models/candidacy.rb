class Candidacy < ApplicationRecord
  belongs_to :candidate
  belongs_to :vote
  has_many :ballot_candidacies, dependent: :destroy

  class << self
    def without_losing(vote_id)
      where(vote_id: vote_id)  
      .where.not(
        id: Round.without_having_loser.where(vote_id: vote_id).pluck(:lose_candidacy_id)
      )
    end
  end
end
