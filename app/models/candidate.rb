class Candidate < ApplicationRecord
  belongs_to :election
  has_many :candidacies

  validates :title, presence: true
end
