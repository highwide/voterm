require 'rails_helper'

RSpec.describe Round, type: :model do
  let(:election) { create(:election, :with_vote_and_4candidacies) }
  let(:vote) { election.votes.first }
  let(:irv_param) { IrvParameter.new(vote.id) }
  let(:c_ids) { vote.candidacies.pluck(:id) }
  let!(:ballot) { create(:ballot, :with_ballot_candidacies, vote: vote) }

  xdescribe 'calc_winner' do
    subject { Round.calc_winner(irv_param) }

    context '正常系' do
      context '過半数を占める候補がある場合' do
        let(:calc_params) do
          [
            [c_ids[0], c_ids[1], c_ids[2], c_ids[3]],
            [c_ids[0], c_ids[2], c_ids[1], c_ids[3]],
            [c_ids[1], c_ids[3], c_ids[2], c_ids[1]]
          ]
        end

        it 'roundを保存し、過半数をとったcandidacyのidを返す' do
          aggregate_failures do
            expect { subject }.to change { Round.count }.by(1)
            is_expected.to eq c_ids[0]
          end
        end
      end

      context '過半数を占める候補がない場合' do
        context 'ラウンドごとの敗者が一位票で決まる場合' do
          let(:calc_params) do
            [
              [c_ids[0], c_ids[1], c_ids[2], c_ids[3]],
              [c_ids[0], c_ids[1], c_ids[2], c_ids[3]],
              [c_ids[1], c_ids[2], c_ids[3], c_ids[0]],
              [c_ids[1], c_ids[2], c_ids[3], c_ids[0]],
              [c_ids[2], c_ids[0], c_ids[1], c_ids[3]]
            ]
            # ↑1ラウンド目のloser: c_ids[3]
            #
            # 2ラウンド目のcalc_params
            # [
            #   [c_ids[0], c_ids[1], c_ids[2]],
            #   [c_ids[0], c_ids[1], c_ids[2]],
            #   [c_ids[1], c_ids[2], c_ids[0]],
            #   [c_ids[1], c_ids[2], c_ids[0]],
            #   [c_ids[2], c_ids[0], c_ids[1]]
            # ]
            # ↑2ラウンド目のloser: c_ids[2]
            #
            # 次にc_ids[2]が落ちるので3ラウンド目でこうなる↓
            # [
            #   [c_ids[0], c_ids[1]],
            #   [c_ids[0], c_ids[1]],
            #   [c_ids[1], c_ids[0]],
            #   [c_ids[1], c_ids[0]],
            #   [c_ids[0], c_ids[1]]
            # ]
            # ↑3ラウンド目にc_ids[0]が過半数をとってwinner
          end

          it '途中のラウンドを保存しつつ、最終的に過半数をとったcandidacyのidを返す' do
            aggregate_failures do
              expect { subject }.to change { Round.count }.by(3)
              is_expected.to eq c_ids[0]
            end
          end
        end

        context 'ラウンドごとの敗者が一位票だけで決まらない場合' do
          let(:calc_params) do
            [
              [c_ids[0], c_ids[1], c_ids[2], c_ids[3]],
              [c_ids[1], c_ids[0], c_ids[2], c_ids[3]],
              [c_ids[2], c_ids[1], c_ids[0], c_ids[3]],
              [c_ids[3], c_ids[1], c_ids[2], c_ids[0]]
            ]
            # 1ラウンド目の1位の票が0〜3まで1票でならぶので敗者が決められない
            # 2位票を見ると、得票がない敗者は2か3になる
            # 3位票を見ると、2が3票集まっており、敗者は3となる
            #
            # 2ラウンド目開始時点
            # [
            #   [c_ids[0], c_ids[1], c_ids[2]],
            #   [c_ids[1], c_ids[0], c_ids[2]],
            #   [c_ids[2], c_ids[1], c_ids[0]],
            #   [c_ids[1], c_ids[0], c_ids[2]]
            # ]
            # 1位票が1票のみの0か2が敗者候補となる
            # 2位票を見ると、2の得票がないため、敗者は2になる
            #
            # 3ラウンド目開始時点
            # [
            #   [c_ids[0], c_ids[1]],
            #   [c_ids[1], c_ids[0]],
            #   [c_ids[1], c_ids[0]],
            #   [c_ids[1], c_ids[0]]
            # ]
            # 過半数をとった1が勝者。
          end

          it '途中のラウンドを保存しつつ、最終的に過半数をとったcandidacyのidを返す' do
            aggregate_failures do
              expect { subject }.to change { Round.count }.by(3)
              is_expected.to eq c_ids[1]
            end
          end
        end
      end
    end

    context '異常系' do
      context 'calc_paramsが空だった場合' do
        let(:calc_params) { [] }
      end

      context 'calc_paramsがnilだった場合' do
        let(:calc_params) { nil }
      end
    end
  end
end