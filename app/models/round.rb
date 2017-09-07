class Round < ApplicationRecord
  belongs_to :vote
  has_one :loser, class_name: 'Candidacy', foreign_key: 'lose_candidacy_id'

  scope :without_having_loser, -> { where.not(lose_candidacy_id: nil) }

  class << self
    def calc_winner(vote_id, calc_params, order_num: 1)
      popular_id, popular_count = popular_candidacy_and_ballot_count(calc_params)
      if popular_count / calc_params.length.to_f > 0.5 # 過半数
        create!(vote_id: vote_id, order_num: order_num, report: winner_report(calc_params, popular_id))
        return popular_id
      else
        loser_id = calc_loser(vote_id, calc_params)
        create!(
          vote_id: vote_id,
          lose_candidacy_id: loser_id,
          order_num: order_num,
          report: loser_report(loser_id)
        )
        calc_winner(vote_id, params_without_loser(calc_params, loser_id), order_num: order_num + 1)
      end
    end

    private

    def winner_report(calc_params, popular_id)
      first_rank_ids_with_count = \
        calc_params
          .first
          .each_with_object({}) { |key, hash| hash[key] = calc_params.map(&:first).count(key) }

      report = \
        Candidacy
          .includes(:candidate)
          .where(id: first_rank_ids_with_count.keys)
          .each_with_object([]) do |c, report|
            report << "・#{c.candidate.title}: 獲得票数 #{first_rank_ids_with_count.fetch(c.id)} "
          end

      report << "\n=> Winner: #{Candidacy.find(popular_id).candidate.title}"

      report.join("\n")
    end

    def loser_report(loser_id)
      "Loser: #{Candidacy.find(loser_id).candidate.title}"
    end

    def params_without_loser(calc_params, loser_id)
      calc_params.map { |ary| ary.reject { |a| a == loser_id } }
    end

    def popular_candidacy_and_ballot_count(calc_params)
      calc_params
        .map(&:first)
        .group_by(&:itself)
        .transform_values(&:length)
        .max_by { |_, v| v }
    end

    def calc_loser(vote_id, calc_params)
      ids_with_count = ids_with_count(vote_id, calc_params)
      loser_ballots_count = ids_with_count.values.min
      unpopular_ids = ids_with_count.select { |_, v| v == loser_ballots_count }.keys
      loser_id = unpopular_ids.length == 1 ? unpopular_ids.first : unpopular_ids.sample
      loser_id
    end

    def ids_with_count(vote_id, calc_params)
      Candidacy
        .without_losing(vote_id)
        .pluck(:id)
        .each_with_object({}) do |id, hash|
          hash[id] = calc_params.map(&:first).count(id)
        end
    end
  end
end