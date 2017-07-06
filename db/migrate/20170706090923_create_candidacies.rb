class CreateCandidacies < ActiveRecord::Migration[5.1]
  def change
    create_table :candidacies do |t|
      t.integer :candidate_id, null: false
      t.integer :vote_id, null: false
      t.integer :rank, null: false

      t.timestamps
    end
  end
end
