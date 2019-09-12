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

ActiveRecord::Schema.define(version: 2019_09_12_020242) do

  create_table "areas", force: :cascade do |t|
    t.string "name", null: false
    t.integer "location", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "centers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string "name", null: false
    t.integer "area_id", null: false
    t.boolean "is_clockwise", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_courses_on_area_id"
  end

  create_table "grades", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbr"
    t.integer "ordering", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inbreed_effects", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jockeys", force: :cascade do |t|
    t.string "name", null: false
    t.integer "stable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stable_id"], name: "index_jockeys_on_stable_id"
  end

  create_table "lineages", force: :cascade do |t|
    t.string "name", null: false
    t.string "name_eng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mare_maternal_lines", force: :cascade do |t|
    t.integer "mare_id", null: false
    t.integer "generation", null: false
    t.integer "father_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mare_id"], name: "index_mare_maternal_lines_on_mare_id"
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

  create_table "nicks", force: :cascade do |t|
    t.integer "lineage1_id", null: false
    t.integer "lineage2_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "racers", force: :cascade do |t|
    t.string "name", null: false
    t.integer "ranch_id", null: false
    t.integer "father_id"
    t.integer "mother_id"
    t.integer "year_birth"
    t.string "comment_age2"
    t.string "comment_age3"
    t.integer "stable_id"
    t.integer "weight_fat"
    t.integer "weight_best"
    t.integer "weight_lean"
    t.string "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ranch_id"], name: "index_racers_on_ranch_id"
    t.index ["stable_id"], name: "index_racers_on_stable_id"
  end

  create_table "races", force: :cascade do |t|
    t.integer "month", null: false
    t.integer "week", null: false
    t.integer "course_id", null: false
    t.string "age", null: false
    t.integer "grade_id", null: false
    t.string "name"
    t.string "abbr"
    t.boolean "is_turf", default: true, null: false
    t.integer "weight", null: false
    t.integer "prize1"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_races_on_course_id"
    t.index ["grade_id"], name: "index_races_on_grade_id"
  end

  create_table "ranch_mares", force: :cascade do |t|
    t.integer "ranch_id", null: false
    t.integer "mare_id", null: false
    t.integer "year_birth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mare_id"], name: "index_ranch_mares_on_mare_id"
    t.index ["ranch_id"], name: "index_ranch_mares_on_ranch_id"
  end

  create_table "ranches", force: :cascade do |t|
    t.string "name"
    t.integer "year"
    t.integer "month"
    t.integer "week"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "stables", force: :cascade do |t|
    t.string "name", null: false
    t.integer "center_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["center_id"], name: "index_stables_on_center_id"
  end

end
