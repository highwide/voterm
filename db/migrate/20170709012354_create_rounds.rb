class CreateRounds < ActiveRecord::Migration[5.1]
  def change
    create_table :rounds do |t|
      t.references :vote, foreign_key: true
      t.integer :lose_candidacy_id
      t.integer :order_num, null: false
      t.text :report, null: false

      t.timestamps
    end

    add_foreign_key :rounds, :candidacies, column: :lose_candidacy_id
  end
end
