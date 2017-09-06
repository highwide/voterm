class ChangeNameOfBallot < ActiveRecord::Migration[5.1]
  def change
    change_column_null :ballots, :name, false, 'No name'
  end
end
