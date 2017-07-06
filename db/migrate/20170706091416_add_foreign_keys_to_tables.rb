class AddForeignKeysToTables < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :elections, :users
    add_foreign_key :votes, :elections
    add_foreign_key :votes, :users
    add_foreign_key :candidates, :elections
    add_foreign_key :candidates, :users
    add_foreign_key :candidacies, :candidates
    add_foreign_key :candidacies, :votes
    add_foreign_key :ballots, :candidacies
    add_foreign_key :ballots, :users
  end
end
