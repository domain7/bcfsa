class SkillAssessmentsController < ApplicationController
  def index
  if (search_params['district_id'] && search_params['district_id'].count > 0 ) || search_params['top'].present?
    @skill_assessments = SkillAssessment.search(search_params.symbolize_keys)
  else
    @skill_assessments = []
  end
    render json: @skill_assessments, each_serializer: SkillAssessmentSerializer
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
      :school_year,
      :top,
      :district_id => []
    )
  end
end
