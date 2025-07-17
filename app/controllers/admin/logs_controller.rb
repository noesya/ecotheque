class Admin::LogsController < Admin::ApplicationController
  load_and_authorize_resource class: 'User::Log'

  include Admin::FiltersHelper

  def index
    @logs = @logs.ordered
    
    respond_to do |format|
      format.html {
        @logs = @logs.page(params[:page])
        breadcrumb
        add_breadcrumb User::Log.model_name.human(count: 2)
      }
      format.xlsx {
        @log_ids = @logs.pluck(:id)
        filename = "downloads-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
        if @logs.count > 1000
          Admin::ExportLogsJob.perform_later(user: current_user, filename: filename, log_ids: @log_ids)
          redirect_back fallback_location: admin_logs_url,
                        notice: t('admin.export_launched')
        else
          response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
        end
      }
    end


  end

end