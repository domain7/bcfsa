class CreateFoobas < ActiveRecord::Migration
  def change
    create_table :skill_assessments do |t|
      t.string :school_year
      t.string :data_level
      t.string :public_or_independent
      t.string :district_number
      t.string :district_name
      t.string :school_number
      t.string :school_name
      t.string :sub_population
      t.string :fsa_skill_code
      t.string :grade
      t.string :number_expected_writers
      t.string :number_writers
      t.string :number_unknown
      t.string :percent_unknown
      t.string :number_below
      t.string :percent_below
      t.string :number_meeting
      t.string :percent_meeting
      t.string :number_exceeding
      t.string :percent_exceeding
      t.string :number_meet_or_exceed
      t.string :percent_meet_or_exceed
      t.string :score_type
      t.string :score
      t.string :participation_rate
    end
    add_index :skill_assessments, [:school_year, :school_number]

    create_table :locations do |t|
      t.string :school_year
      t.string :public_or_independent
      t.string :district_number
      t.string :district_long_name_this_enrol
      t.string :school_number
      t.string :school_name
      t.string :school_facility_type
      t.string :school_physical_address
      t.string :school_city
      t.string :school_province
      t.string :school_postal_code
      t.string :school_phone_number
      t.string :school_fax_number
      t.string :school_latitude
      t.string :school_longitude
      t.string :organization_education_level
      t.string :grade_string
      t.string :has_elementary_grades_flag
      t.string :has_secondary_grades_flag
    end
    add_index :locations, [:school_year, :school_number], unique: true
  end
end
