class SkillAssessment < ActiveRecord::Base
  cattr_accessor :scale_reading, :scale_writing, :scale_numeracy

  def self.with_locations
    self.select('skill_assessments.*, locations.*').
      joins('JOIN locations ON locations.school_year = skill_assessments.school_year AND locations.school_number = skill_assessments.school_number')
  end

  def self.writing_scale
    @@scale_writing ||= self.where(fsa_skill_code: 'Writing', score_type: 'PROPORTIONAL_SCALED_SCORE').where("score > '0' AND score < '999'").maximum(:score).to_f
  end

  def self.reading_scale
    @@scale_reading ||= self.where(fsa_skill_code: 'Reading', score_type: 'IRT_SCORE').where("score > '0' AND score < '999'").maximum(:score).to_f
  end

  def self.numeracy_scale
    @@scale_numeracy ||= self.where(fsa_skill_code: 'Numeracy', score_type: 'IRT_SCORE').where("score > '0' AND score < '999'").maximum(:score).to_f
  end


  def self.search(options={})

    options = { school_year: '2012/2013', data_level: 'SCHOOL LEVEL', sub_population: 'ALL STUDENTS' }.merge(options)
    if  (options[:data_level] == 'SCHOOL LEVEL')
    out = self.with_locations
    else
      out = self.where(nil)
    end
    out.where!(data_level: options[:data_level], sub_population: options[:sub_population], school_year: options[:school_year])

    if options[:q]
      #do a smart search
    end

    if options[:nw_lat] && options[:nw_lng] && options[:se_lat] && options[:se_lng]
      out.where!( school_latitude: (:se_lat..:nw_lat), school_longitude: (:nw_lng..:se_lng) )
    end

    if options[:grade].present?
      out.where!( grade: options[:grade])
    end

    if options[:grade_string].present?
      out.where!( grade_string: options[:grade_string])
    end

    if options[:district_id].present?
      out.where!( district_number: options[:district_id] )
    end

    if options[:fsa_skill_code].present?
      out.where!( fsa_skill_code: options[:fsa_skill_code])
    end

    if options[:top].present?
        out.where!("score != 'Msk'").
        where!("number_writers != 'Msk'").
        where!("(number_writers::Integer) > 15")

      out.order(score: :desc).limit( options[:top].to_i)
    else
      out.limit(500)
    end

  end

end
