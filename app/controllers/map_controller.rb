class MapController < ApplicationController
  def index
    @districts = Location.where.not(district_number: nil).select('DISTINCT district_number,district_long_name_this_enrol AS name').order(:district_long_name_this_enrol)
  end
end
