class Admin::ExportLogsJob < ApplicationJob
  include Admin::XlsxExportableJob

  queue_as :default

  def perform(user:, filename:, log_ids:)
    xlsx = ApplicationController.new.render_to_string(
      layout: false,
      handlers: [:fast_excel],
      formats: [:xlsx],
      template: "admin/logs/index",
      locals: { log_ids: log_ids }
    )
    export = create_export(user, xlsx, filename)
    AdminMailer.with(export: export).export_logs.deliver_later
    GC.start
  end
end