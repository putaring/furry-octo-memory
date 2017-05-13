class ReportsController < ApplicationController
  before_action :authenticate!

  def show
    @report = current_user.reports.find(params[:id])
  end

  def create
    @report = current_user.reports.create!(report_params)
    redirect_to report_path(@report)
  end

  private
    def report_params
      params.require(:report).permit(:reported_id, :description, :reason)
    end
end
