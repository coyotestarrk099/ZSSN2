class ReportListsController < ApplicationController
  before_action :set_report_list, only: [:show, :update, :destroy]

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

    if Survivor.where("id = ?", @report_list.reportedId).blank? == false and Survivor.where("id = ?", @report_list.reporterId).blank? == false
      if ReportList.where("reportedId = ? and reporterId = ?", @report_list.reportedId, @report_list.reporterId).blank? == false
        render json: {
            success: false,
            msg: "Server: Calm down!!! You already reported this user. Community thanks you for your effort."
          }.to_json, status: :unprocessable_entity         
      else
        if  Survivor.where("id = ? and infected < 3", @report_list.reporterId).count == 1
          @suspect = Survivor.where("id = ?", @report_list.reportedId).last
          @suspect.update(infected: @suspect.infected + 1)
            if @report_list.save
              render json: @report_list, status: :created, location: @report_list
            else
              render json: @report_list.errors, status: :unprocessable_entity
            end
        else
         render json: {
            success: false,
            msg: "I don't know who you are. I don't know what you want. If you are looking for ransom I can tell you I don't have brains, but what I do have are a very particular set of skills. Skills I have acquired over a very long career. Skills that make me a nightmare for zombies like you. If you go out of my server now that'll be the end of it. I will not look for you, I will not pursue you, but if you don't, I will look for you, I will find you and I will kill you."
          }.to_json, status: :unprocessable_entity
        end
      end
    else
      render json: {
            success: false,
            msg: "Skynet: User don't exist yet!!!Are you John Connor??"
          }.to_json, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /report_lists/1
  def update
    if @report_list.update(report_list_params)
      render json: @report_list
    else
      render json: @report_list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /report_lists/1
  def destroy
    @report_list.destroy
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