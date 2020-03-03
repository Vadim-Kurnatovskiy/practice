class UtilsController < ApplicationController
   # GET /
  def index
    washes = Carwash.with_coordinates
    begin
      user_lat, user_lng = determine_user_coords
      @carwashes = washes.select{|cw| haversine_distance(user_lat, user_lng, cw.lat, cw.lng) < 3000}
    rescue Errno::ENOENT
      logger.warn('Problem accessing GeoLiteCity.dat')
      @carwashes = []
    rescue NoMethodError
      @carwashes = []
    end
  end
  
  # GET /nearest_carwashes
  def nearest_carwashes
    washes = Carwash.with_coordinates
    lat, lng = params[:lat].to_f, params[:lng].to_f
    @carwashes = washes.select {|cw| haversine_distance(lat, lng, cw.lat, cw.lng) < 3000}
    if params[:map]
      render "utils/_onmap_carwashes", layout: false
    else
      render "_carwashes", layout: false
    end
  end  
end