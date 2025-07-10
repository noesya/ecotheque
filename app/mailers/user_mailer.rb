class UserMailer < ApplicationMailer
  default template_path: 'mailers/user'

  def welcome_message
    @user = params[:user]
    return unless should_send?(@user.email)
    welcome_message_content = MailerContent.find_by(identifier: 'welcome_message')
    return unless welcome_message_content.try(:published?)
    @body = welcome_message_content.body
    mail(
      to: @user.email,
      subject: welcome_message_content.subject
    )
  end

end
