class Admin::FileExportsController < Admin::ApplicationController
  load_and_authorize_resource class: "Admin::FileExport", find_by: :uuid

  def show
    if @file_export.expires_at < Time.zone.now
      redirect_to admin_root_path, alert: t('admin.export_expired'), status: 301
    else
      redirect_to rails_blob_path(@file_export.file, disposition: "attachment")
    end
  end

end