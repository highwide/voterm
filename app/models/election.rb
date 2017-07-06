class Election < ApplicationRecord
  has_many :votes
  has_many :candidates

  validates :title, presence: true
end
