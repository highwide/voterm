class CreateResults < ActiveRecord::Migration[5.1]
  def change
    create_table :results do |t|
      t.references :vote, foreign_key: true
      t.integer :win_candidacy_id, null: false

      t.timestamps
    end

    add_foreign_key :results, :candidacies, column: :win_candidacy_id
  end
end
