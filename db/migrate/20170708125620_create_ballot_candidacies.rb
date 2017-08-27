class CreateBallotCandidacies < ActiveRecord::Migration[5.1]
  def change
    create_table :ballot_candidacies do |t|
      t.integer :ballot_id, null: false
      t.integer :candidacy_id, null: false
      t.integer :rank, null: false

      t.timestamps
    end

    add_foreign_key :ballot_candidacies, :ballots
    add_foreign_key :ballot_candidacies, :candidacies
  end
end
