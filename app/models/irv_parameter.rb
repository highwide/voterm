class IrvParameter
  attr_reader :vote_id, :loser_id

  def initialize(vote_id)
    @vote_id = vote_id

    ballot_candidacies = BallotCandidacy.by_vote_id(vote_id)
    raise 'emtpy ballot_candidacies error' if ballot_candidacies.blank?

    @candidacy_ids = ballot_candidacies.pluck(:candidacy_id).uniq
    @ballot_ids = ballot_candidacies.pluck(:ballot_id).uniq

    @ordered_ids_by_ballot = to_ordered_ids(ballot_candidacies)
    @ballots_count = aggregate_ballots(@ordered_ids_by_ballot)
    @loser_id = calc_loser
  end

  def exist_majority?
    !!majority_id
  end

  def majority_id
    candidacy_id, count = @ballots_count.first.max { |a, b| a[1] <=> b[1] }
    return candidacy_id if count / @ballot_ids.count.to_f > 0.5

    nil
  end

  def report
    return report_when_win if exist_majority?
    report_when_lose
  end

  def remove_loser!
    @candidacy_ids.delete(@loser_id)
    @ordered_ids_by_ballot.map! { |ids| ids.reject { |id| id == @loser_id } }
    @ballots_count = aggregate_ballots(@ordered_ids_by_ballot)
    @loser_id = calc_loser
    self
  end

  private

  # input: [[A, B, C], [B, A, C], [C, A, B]]
  # output:
  #   [
  #     {A => 1, B => 1, C => 1}, # count of 1st ranked ballots
  #     {A => 2, B => 1, C => 0}, # count of 2nd ranked ballots
  #     {A => 0, B => 1, C => 2}  # count of 3rd ranked ballots
  #   ]
  def aggregate_ballots(ordered_ids_by_ballot)
    count_ordered_by_rank = @candidacy_ids.map do |_|
      @candidacy_ids.each_with_object({}) { |id, hash| hash[id] = 0 }
    end
    ordered_ids_by_ballot.each do |ids|
      ids.each_with_index { |id, i| count_ordered_by_rank[i][id] += 1}
    end
    count_ordered_by_rank
  end

  def to_ordered_ids(ballot_candidacies)
    ballot_candidacies
      .group_by(&:ballot_id)
      .map { |_, v| v.sort_by(&:rank).pluck(:candidacy_id) }
  end

  def calc_loser
    return nil if exist_majority?

    target_ids = @ballots_count.first.keys
    @ballots_count.each do |hash|
      hash = hash.select { |id, count| id.in? target_ids }
      min_count = hash.min { |a, b| a[1] <=> b[1] }.second
      min_count_ids = hash.select { |id, count| count == min_count }.keys
      return min_count_ids.first if min_count_ids.count == 1
      target_ids = min_count_ids
    end
    target_ids.sample
  end

  def report_when_win
    candidacies = Candidacy.includes(:candidate).where(id: @candidacy_ids)
    texts = candidacies.each_with_object([]) do |c, texts|
      count_of_ballot = @ballots_count.first[c.id]
      candidate_title = c.candidate.title
      texts << "・#{candidate_title}: 獲得票数 #{count_of_ballot} "
    end

    texts << "\n=> Winner: #{Candidacy.find(majority_id).candidate.title}"
    texts.join("\n")
  end

  def report_when_lose
    "Loser: #{Candidacy.find(@loser_id).candidate.title}"
  end
end