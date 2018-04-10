class CampsController < ApplicationController

  swagger_controller :camps, "Camp Management"

  swagger_api :index do
    summary "Fetches all Camps"
    notes "This lists all of the camps"
  end

  swagger_api :show do
    summary "Shows one Camp"
    param :path, :id, :integer, :required, "Camp ID"
    notes "This lists details of one camp"
    response :not_found
  end



  # Controller Code

  before_action :set_camp, only: [:show]

  # GET /camps
  def index
    @camps = Camp.all

    render json: @camps
  end

  # GET /camp/1
  def show
    render json: @camp
  end

 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_camp
      @camp = Camp.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def camp_params
      params.permit(:curriculum_id, :location_id, :cost, :start_date, :end_date, :time_slot, :max_students, :active)
    end
end