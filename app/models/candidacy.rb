class Candidacy < ApplicationRecord
  belongs_to :candidate
  belongs_to :vote

  validates :rank, numricality: { only_integer: true }
end
