class Admin::ReportsController < Admin::AdminController

  def show
    @report = Report.find(params[:id])
    redirect_to edit_admin_report_path(@report) unless @report.resolved?
  end

  def edit
    @report = Report.find(params[:id])
    redirect_to admin_report_path(@report) if @report.resolved?
  end

  def update
    @report = Report.find(params[:id])
    if @report.update_attributes(report_params)
      redirect_to admin_report_path(@report), notice: "Resolved. The reporter has been notified."
    else
      render 'edit'
    end
  end

  private
  def report_params
    params.require(:report).permit(:resolved, :resolution)
  end

end
