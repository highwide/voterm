class Ballot < ApplicationRecord
  belongs_to :vote
  has_many :ballot_candidacies, dependent: :destroy

  accepts_nested_attributes_for :ballot_candidacies

  validates_presence_of :name
end
