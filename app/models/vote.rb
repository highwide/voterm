class Vote < ApplicationRecord
  belongs_to :election
  has_many :candidacy
end
