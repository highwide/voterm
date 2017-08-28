class Election < ApplicationRecord
  has_many :votes
  has_many :candidates

  accepts_nested_attributes_for :candidates, allow_destroy: true

  validates :title, presence: true
end
