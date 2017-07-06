class Candidate < ApplicationRecord
  belongs_to :election

  validates :title, presence: true
end