class Candidate < ApplicationRecord
  belongs_to :election
  has_many :candidacies, dependent: :destroy

  validates :title, presence: true
end
