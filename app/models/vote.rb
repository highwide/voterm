class Vote < ApplicationRecord
  belongs_to :election
  has_many :candidacies
  has_many :ballots
  has_many :rounds
  has_one :result

  accepts_nested_attributes_for :candidacies, allow_destroy: true
end
