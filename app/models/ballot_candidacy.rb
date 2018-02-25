class BallotCandidacy < ApplicationRecord
  belongs_to :ballot
  belongs_to :candidacy

  validates :rank, presence: true, numericality: { only_integer: true }

  def self.by_vote_id(vote_id)
    joins(:ballot).where(ballots: { vote_id: vote_id })
  end
end
