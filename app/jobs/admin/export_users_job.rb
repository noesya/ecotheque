class Admin::ExportUsersJob < ApplicationJob
  include Admin::XlsxExportableJob

  queue_as :default

  def perform(user:, filename:, user_ids:)
    xlsx = ApplicationController.new.render_to_string(
      layout: false,
      handlers: [:fast_excel],
      formats: [:xlsx],
      template: "admin/users/index",
      locals: { user_ids: user_ids }
    )
    export = create_export(user, xlsx, filename)
    AdminMailer.with(export: export).export_users.deliver_later
    GC.start
  end
end