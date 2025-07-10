class UserMailer < ApplicationMailer
  default template_path: 'mailers/user'

  def welcome_message
    @user = params[:user]
    return unless should_send?(@user.email)
    content = MailerContent.find_by(identifier: 'welcome_message')
    return unless content.try(:published?)
    @body = content.body
    mail(
      to: @user.email,
      subject: content.subject
    )
  end

end
