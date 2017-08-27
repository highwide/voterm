class AddForeignKeysToTables < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :votes, :elections
    add_foreign_key :candidates, :elections
    add_foreign_key :candidacies, :candidates
    add_foreign_key :candidacies, :votes
    add_foreign_key :ballots, :votes
  end
end
