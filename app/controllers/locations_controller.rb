class LocationsController < ApplicationController

  swagger_controller :locations, "Location Management"

  swagger_api :index do
    summary "Fetches all location"
    notes "This lists all the location"
  end

  swagger_api :show do
    summary "Shows one Location"
    param :path, :id, :integer, :required, "Location ID"
    notes "This lists details of one Location"
    response :not_found
  end



  # Controller Code

  before_action :set_location, only: [:show]

  # GET /locations
  def index
    @locations = Location.all

    render json: @locations
  end

  # GET /location/1
  def show 
    render json: @location
  end

 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def location_params
      params.permit(:name, :street_1, :street_2, :city, :state, :zip, :max_capacity, :active)
    end
end