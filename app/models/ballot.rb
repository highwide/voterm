class Ballot < ApplicationRecord
  belongs_to :candidacy
  belongs_to :users

  validates :rank, presence: true, numericality: { only_integer: true }
end
