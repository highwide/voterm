class BallotCandidacy < ApplicationRecord
  belongs_to :ballot
  belongs_to :candidacy

  validates :rank, presence: true, numericality: { only_integer: true }

  # 同一vote_idの票をrank順にcandidacy_idを並べたballotごとの二重配列にする
  def self.to_calc_params(vote_id)
    joins(:ballot)
      .where(ballots: { vote_id: vote_id })
      .group_by(&:ballot_id)
      .map { |_, v| v.sort_by(&:rank).pluck(:candidacy_id) }
  end
end
