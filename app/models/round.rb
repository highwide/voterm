class Round < ApplicationRecord
  belongs_to :vote
  has_one :loser, class_name: 'Candidacy', foreign_key: 'lose_candidacy_id'

  scope :without_having_loser, -> { where.not(lose_candidacy_id: nil) }

  class << self
    def calc_winner(irv_param, order_num =  1)
      create!(create_args(irv_param, order_num))
      return irv_param.majority_id if irv_param.exist_majority?

      calc_winner(irv_param.remove_loser!, order_num + 1)
    end

    private

    def create_args(irv_param, order_num)
      {
        vote_id: irv_param.vote_id,
        lose_candidacy_id: irv_param.loser_id,
        order_num: order_num,
        report: irv_param.report
      }
    end
  end
end