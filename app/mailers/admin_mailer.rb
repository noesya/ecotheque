class AdminMailer < ApplicationMailer
  default template_path: 'mailers/admin'

  def export_users
    export_xlsx
  end

  def export_logs
    export_xlsx
  end

  protected

  def export_xlsx
    @export = params[:export]
    subject = I18n.t('mailers.export_ok.subject')
    mail(to: @export.user.email, subject: subject)
  end

end