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

ActiveRecord::Schema.define(version: 2019_09_10_010547) do

  create_table "inbreed_effects", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lineages", force: :cascade do |t|
    t.string "name", null: false
    t.string "name_eng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mares", force: :cascade do |t|
    t.string "name", null: false
    t.integer "father_id"
    t.integer "lineage_id"
    t.integer "price"
    t.integer "speed"
    t.integer "stamina"
    t.boolean "has_child"
    t.string "rating"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lineage_id"], name: "index_mares_on_lineage_id"
  end

  create_table "root_lineages", force: :cascade do |t|
    t.integer "number", null: false
    t.string "name", null: false
    t.string "name_eng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sire_inbreed_effects", force: :cascade do |t|
    t.integer "sire_id", null: false
    t.integer "inbreed_effect_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inbreed_effect_id"], name: "index_sire_inbreed_effects_on_inbreed_effect_id"
    t.index ["sire_id"], name: "index_sire_inbreed_effects_on_sire_id"
  end

  create_table "sire_maternal_lines", force: :cascade do |t|
    t.integer "sire_id", null: false
    t.integer "generation", null: false
    t.integer "father_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sire_id"], name: "index_sire_maternal_lines_on_sire_id"
  end

  create_table "sire_traits", force: :cascade do |t|
    t.integer "sire_id", null: false
    t.integer "lineage_id", null: false
    t.integer "fee", null: false
    t.integer "min_distance", null: false
    t.integer "max_distance", null: false
    t.string "dirt", null: false
    t.string "growth", null: false
    t.string "temper", null: false
    t.string "contend", null: false
    t.string "health", null: false
    t.string "achievement", null: false
    t.string "stability", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lineage_id"], name: "index_sire_traits_on_lineage_id"
    t.index ["sire_id"], name: "index_sire_traits_on_sire_id"
  end

  create_table "sires", force: :cascade do |t|
    t.string "name_jp"
    t.string "name_eng"
    t.integer "father_id"
    t.integer "root_lineage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["root_lineage_id"], name: "index_sires_on_root_lineage_id"
  end

end
