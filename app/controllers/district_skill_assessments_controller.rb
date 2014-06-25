class DistrictSkillAssessmentsController < ApplicationController
  def index
    p = {data_level: 'DISTRICT LEVEL'}.merge(search_params.symbolize_keys)
    @skill_assessments = SkillAssessment.search(p)
    render json: @skill_assessments, each_serializer: DistrictSkillAssessmentSerializer
  end

  private

  def search_params
    params.permit(
      :q,
      :nw_lat,
      :nw_lng,
      :se_lat,
      :se_lng,
      :fsa_skill_code,
      :grade,
      :district_id,
      :school_year
    )
  end
end
