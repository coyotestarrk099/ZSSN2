class ReportListsController < ApplicationController
  before_action :set_report_list, only: [:show]

  # GET /report_lists
  def index
    @report_lists = ReportList.all

    render json: @report_lists
  end

  # GET /report_lists/1
  def show
    render json: @report_list
  end

  # POST /report_lists
  def create
    @report_list = ReportList.new(report_list_params)

    result = VerifyReportService.new({reportedId: @report_list.reportedId, reporterId: @report_list.reporterId}).charge
    if (result == 1)
      if @report_list.save
        render json: @report_list, status: :created, location: @report_list
      else
        render json: @report_list.errors, status: :unprocessable_entity
      end
    else
      if (result == 2)
        msg = "Lori: Calm down!!! You already reported this user. Community thanks you for your effort."
      elsif (result == 3)
        msg = "Lori: I don't know who you are. I don't know what you want. If you are looking for ransom I can tell you I don't have brains, but what I do have are a very particular set of skills. Skills I have acquired over a very long career. Skills that make me a nightmare for zombies like you. If you go out of my server now that'll be the end of it. I will not look for you, I will not pursue you, but if you don't, I will look for you, I will find you and I will kill you."
      elsif (result == 4)
        msg = "Skynet: User don't exist yet!!!Are you John Connor??"
      end
      render json: {
          success: false,
          msg: msg
        }.to_json, status: :unprocessable_entit
    end
  end

  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report_list
      @report_list = ReportList.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def report_list_params
      params.require(:report_list).permit(:reportedId, :reporterId)
    end
end