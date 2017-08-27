class Round < ApplicationRecord
  belongs_to :vote
  has_one :loser, class_name: 'Candidacy', foreign_key: 'lose_candidacy_id'

  class << self
    def calc_winner(vote_id, calc_params, order_num: 1)
      popular_id, popular_count = popular_candidacy_and_ballot_count(calc_params)
      if popular_count / calc_params.length.to_f > 0.5 # 過半数
        create!(
          vote_id: vote_id,
          order_num: order_num,
          report: "Winner: #{Candidacy.find(popular_id).candidate.title} / 得票: #{popular_count}"
        )
        return popular_id
      else
        loser_id = calc_loser(vote_id, calc_params)
        create!(
          vote_id: vote_id,
          lose_candidacy_id: loser_id,
          order_num: order_num,
          report: "Loser: #{Candidacy.find(loser_id).candidate.title}"
        )
        calc_winner(
          vote_id,
          calc_params.map { |ary| ary.reject { |a| a == loser_id } },
          order_num: order_num + 1
        )
      end
    end

    private

    def popular_candidacy_and_ballot_count(calc_params)
      calc_params
        .map(&:first)
        .group_by(&:itself)
        .transform_values(&:length)
        .max_by { |_, v| v }
    end

    def calc_loser(vote_id, calc_params)
      having_loser_rounds = Round.where(vote_id: vote_id).where.not(lose_candidacy_id: nil)
      ids = Candidacy.where(vote_id: vote_id).where.not(id: having_loser_rounds.pluck(:lose_candidacy_id)).pluck(:id)
      ids_with_count = ids.each_with_object({}) do |id, hash|
        hash[id] = calc_params.map(&:first).count(id)
      end
      loser_ballots_count = ids_with_count.values.min
      unpopular_ids = ids_with_count.select { |_, v| v == loser_ballots_count }.keys
      loser_id = unpopular_ids.length == 1 ? unpopular_ids.first : unpopular_ids.sample

      loser_id
    end
  end
end