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

ActiveRecord::Schema.define(version: 2021_01_13_002133) do

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

  create_table "handicap_loads", force: :cascade do |t|
    t.integer "racer_id"
    t.integer "grade_id"
    t.integer "load"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grade_id"], name: "index_handicap_loads_on_grade_id"
    t.index ["racer_id"], name: "index_handicap_loads_on_racer_id"
  end

  create_table "in_ranches", force: :cascade do |t|
    t.integer "racer_id", null: false
    t.integer "month", null: false
    t.integer "week", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_in_spa", default: false, null: false
    t.index ["racer_id"], name: "index_in_ranches_on_racer_id"
  end

  create_table "inbreed_caches", force: :cascade do |t|
    t.integer "mare_id", null: false
    t.integer "sire_id", null: false
    t.string "h_inbreeds_in_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mare_id"], name: "index_inbreed_caches_on_mare_id"
    t.index ["sire_id"], name: "index_inbreed_caches_on_sire_id"
  end

  create_table "inbreed_effects", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score", default: 0, null: false
  end

  create_table "injuries", force: :cascade do |t|
    t.integer "racer_id"
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["racer_id"], name: "index_injuries_on_racer_id"
  end

  create_table "jockeys", force: :cascade do |t|
    t.string "name", null: false
    t.integer "stable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "center_id"
    t.integer "ordering"
    t.index ["center_id"], name: "index_jockeys_on_center_id"
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

  create_table "mare_potentials", force: :cascade do |t|
    t.integer "mare_id", null: false
    t.integer "count_nicks"
    t.integer "count_interesting"
    t.integer "count_nicks_and_interesting"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mare_id"], name: "index_mare_potentials_on_mare_id"
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

  create_table "post_races", force: :cascade do |t|
    t.integer "result_id"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["result_id"], name: "index_post_races_on_result_id"
  end

  create_table "prize_patterns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prizes", force: :cascade do |t|
    t.integer "prize_pattern_id", null: false
    t.integer "place", null: false
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prize_pattern_id"], name: "index_prizes_on_prize_pattern_id"
  end

  create_table "racer_name_samples", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "is_crown", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "type", default: 0, null: false
    t.integer "sex", default: 0, null: false
  end

  create_table "racer_trips", force: :cascade do |t|
    t.integer "racer_id"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_racer_trips_on_course_id"
    t.index ["racer_id"], name: "index_racer_trips_on_racer_id"
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
    t.integer "sex"
    t.integer "grade_id"
    t.boolean "is_active", default: true, null: false
    t.integer "grade_given_id"
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
    t.integer "limitation", default: 0, null: false
    t.integer "distance", null: false
    t.integer "weight", null: false
    t.integer "prize1"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "surface", default: 0, null: false
    t.integer "prize_pattern_id"
    t.index ["course_id"], name: "index_races_on_course_id"
    t.index ["grade_id"], name: "index_races_on_grade_id"
    t.index ["prize_pattern_id"], name: "index_races_on_prize_pattern_id"
  end

  create_table "ranch_mares", force: :cascade do |t|
    t.integer "ranch_id", null: false
    t.integer "mare_id", null: false
    t.integer "year_birth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sire_id"
    t.string "remark"
    t.integer "child_status", default: 0, null: false
    t.index ["mare_id"], name: "index_ranch_mares_on_mare_id"
    t.index ["ranch_id"], name: "index_ranch_mares_on_ranch_id"
    t.index ["sire_id"], name: "index_ranch_mares_on_sire_id"
  end

  create_table "ranch_sires", force: :cascade do |t|
    t.integer "ranch_id", null: false
    t.integer "sire_id", null: false
    t.integer "year_leased", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ranch_id"], name: "index_ranch_sires_on_ranch_id"
    t.index ["sire_id"], name: "index_ranch_sires_on_sire_id"
  end

  create_table "ranches", force: :cascade do |t|
    t.string "name"
    t.integer "year"
    t.integer "month"
    t.integer "week"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_racers", default: 6, null: false
    t.integer "max_mares", default: 2, null: false
  end

  create_table "results", force: :cascade do |t|
    t.integer "racer_id", null: false
    t.integer "race_id", null: false
    t.integer "ordering"
    t.string "surface_condition"
    t.integer "num_racers"
    t.integer "num_frame"
    t.integer "rank_odds"
    t.float "odds"
    t.integer "place"
    t.integer "weight"
    t.string "mark_development"
    t.string "mark_stamina"
    t.string "mark_contend"
    t.string "mark_temper"
    t.string "mark_odds"
    t.integer "age"
    t.integer "load"
    t.integer "jockey_id"
    t.string "for_bad_surface"
    t.string "position"
    t.string "direction"
    t.string "comment_paddock"
    t.string "comment_race"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "condition"
    t.index ["jockey_id"], name: "index_results_on_jockey_id"
    t.index ["race_id"], name: "index_results_on_race_id"
    t.index ["racer_id"], name: "index_results_on_racer_id"
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

  create_table "target_races", force: :cascade do |t|
    t.integer "racer_id", null: false
    t.integer "race_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_target_races_on_race_id"
    t.index ["racer_id"], name: "index_target_races_on_racer_id"
  end

  create_table "weeklies", force: :cascade do |t|
    t.integer "racer_id", null: false
    t.integer "age", null: false
    t.integer "month", null: false
    t.integer "week", null: false
    t.string "condition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight"
    t.index ["racer_id"], name: "index_weeklies_on_racer_id"
  end

end
