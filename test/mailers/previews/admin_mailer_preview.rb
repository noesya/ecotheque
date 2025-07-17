# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/admin_mailer/export_users
  def export_users
    AdminMailer.with(export: Admin::FileExport.last).export_users
  end

  # Preview this email at http://localhost:3000/rails/mailers/admin_mailer/export_logs
  def export_logs
    AdminMailer.with(export: Admin::FileExport.last).export_logs
  end

end