election = Election.create!(title: '0x64物語reboot テーマ決め')

vote = Vote.create!(title: '第0x01夜', election: election)
Vote.create!(title: '第0x02夜', election: election)

candidates = []
%w(ネットワーク 機械学習 テスト RDB ポストRails).each do |candidate|
  candidates << Candidate.create!(
    title: candidate,
    election: election
  )
end

candidacies = []
candidates.each do |c|
  candidacies << Candidacy.create!(candidate: c, vote: vote)
end

ballots = []
2.times do |i|
  ballots << Ballot.create!(vote: vote, name: "user#{i}")
end

candidacies.each_with_index do |c, i|
  BallotCandidacy.create!(
    ballot: ballots[0],
    candidacy: c,
    rank: i + 1
  )
end

candidacies.reverse.each_with_index do |c, i|
  BallotCandidacy.create!(
    ballot: ballots[1],
    candidacy: c,
    rank: i + 1
  )
end
