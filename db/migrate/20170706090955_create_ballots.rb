class CreateBallots < ActiveRecord::Migration[5.1]
  def change
    create_table :ballots do |t|
      t.integer :candidacy_id, null: false
      t.integer :user_id, null: false
      t.integer :rank, null: false

      t.timestamps
    end
  end
end
