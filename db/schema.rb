# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170906013706) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ballot_candidacies", force: :cascade do |t|
    t.integer "ballot_id", null: false
    t.integer "candidacy_id", null: false
    t.integer "rank", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ballots", force: :cascade do |t|
    t.integer "vote_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "candidacies", force: :cascade do |t|
    t.integer "candidate_id", null: false
    t.integer "vote_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "candidates", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.integer "election_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "elections", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "results", force: :cascade do |t|
    t.bigint "vote_id"
    t.integer "win_candidacy_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vote_id"], name: "index_results_on_vote_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "vote_id"
    t.integer "lose_candidacy_id"
    t.integer "order_num", null: false
    t.text "report", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vote_id"], name: "index_rounds_on_vote_id"
  end

  create_table "votes", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.integer "election_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "ballot_candidacies", "ballots"
  add_foreign_key "ballot_candidacies", "candidacies"
  add_foreign_key "ballots", "votes"
  add_foreign_key "candidacies", "candidates"
  add_foreign_key "candidacies", "votes"
  add_foreign_key "candidates", "elections"
  add_foreign_key "results", "candidacies", column: "win_candidacy_id"
  add_foreign_key "results", "votes"
  add_foreign_key "rounds", "candidacies", column: "lose_candidacy_id"
  add_foreign_key "rounds", "votes"
  add_foreign_key "votes", "elections"
end
