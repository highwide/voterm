class Ballot < ApplicationRecord
  belongs_to :vote
  has_many :ballot_candidacies

  accepts_nested_attributes_for :ballot_candidacies
end
