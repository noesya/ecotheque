class UserMailer < ApplicationMailer
  default template_path: 'mailers/user'

  def welcome_message
    @user = params[:user]
    welcome_message_content = MailerContent.find_by(identifier: 'welcome_message')
    return unless welcome_message_content.try(:published?)
    subject = welcome_message_content.subject
    @body = welcome_message_content.body
    mail(to: @user.email, subject: subject) if should_send?(@user.email)
  end

end
