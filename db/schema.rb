# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140424155214) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locations", force: true do |t|
    t.string "school_year"
    t.string "public_or_independent"
    t.string "district_number"
    t.string "district_long_name_this_enrol"
    t.string "school_number"
    t.string "school_name"
    t.string "school_facility_type"
    t.string "school_physical_address"
    t.string "school_city"
    t.string "school_province"
    t.string "school_postal_code"
    t.string "school_phone_number"
    t.string "school_fax_number"
    t.string "school_latitude"
    t.string "school_longitude"
    t.string "organization_education_level"
    t.string "grade_string"
    t.string "has_elementary_grades_flag"
    t.string "has_secondary_grades_flag"
  end

  add_index "locations", ["school_year", "school_number"], name: "index_locations_on_school_year_and_school_number", unique: true, using: :btree

  create_table "skill_assessments", force: true do |t|
    t.string "school_year"
    t.string "data_level"
    t.string "public_or_independent"
    t.string "district_number"
    t.string "district_name"
    t.string "school_number"
    t.string "school_name"
    t.string "sub_population"
    t.string "fsa_skill_code"
    t.string "grade"
    t.string "number_expected_writers"
    t.string "number_writers"
    t.string "number_unknown"
    t.string "percent_unknown"
    t.string "number_below"
    t.string "percent_below"
    t.string "number_meeting"
    t.string "percent_meeting"
    t.string "number_exceeding"
    t.string "percent_exceeding"
    t.string "number_meet_or_exceed"
    t.string "percent_meet_or_exceed"
    t.string "score_type"
    t.string "score"
    t.string "participation_rate"
  end

  add_index "skill_assessments", ["school_year", "school_number"], name: "index_skill_assessments_on_school_year_and_school_number", using: :btree

end
