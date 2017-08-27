class Election < ApplicationRecord
  has_many :votes
  has_many :candidates

  accepts_nested_attributes_for :candidates

  validates :title, presence: true
end
