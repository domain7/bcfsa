class DistrictSkillAssessmentSerializer < ActiveModel::Serializer
  attributes :id, :school_year, :public_or_independent, :district_number,
    :district_name, :school_number, :school_name, :fsa_skill_code, :grade,
    :participation_rate, :percent_below, :percent_meeting, :percent_exceeding,
    :scaled_score

  def scaled_score
    if object.score.to_f > 0
      scale = "#{object.fsa_skill_code.downcase}_scale"
      object.score.to_f / SkillAssessment.send(scale.to_sym)
    end
  end
end
