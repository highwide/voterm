class User < ApplicationRecord
  has_many :elections
  has_many :votes
  has_many :candidates
  has_many :ballots

  validates :name, presence: true 
end
