class Candidacy < ApplicationRecord
  belongs_to :candidate
  belongs_to :vote
  has_many :ballot_candidacies, dependent: :destroy

  # return { candicacy.id => { rank => count} }
  def self.to_round_calc_params(vote_id)
    where(vote_id: vote_id)
      .includes(:ballot_candidacies)
      .reduce({}) do |hash, c|
        hash.tap { |h| h[c.id] = c.aggregate_ballots }
      end
  end

  def aggregate_ballots
    # ballot_candidacies.group(:rank).count
    ballot_candidacies
      .group_by(&:rank)
      .transform_values(&:count)
  end
end
