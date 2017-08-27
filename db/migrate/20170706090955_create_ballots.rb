class CreateBallots < ActiveRecord::Migration[5.1]
  def change
    create_table :ballots do |t|
      t.integer :vote_id, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
