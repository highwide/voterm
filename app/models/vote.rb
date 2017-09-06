class Vote < ApplicationRecord
  belongs_to :election
  has_many :candidacies, dependent: :destroy
  has_many :ballots, dependent: :destroy
  has_many :rounds, dependent: :destroy
  has_one :result, dependent: :destroy

  accepts_nested_attributes_for :candidacies, allow_destroy: true
end
