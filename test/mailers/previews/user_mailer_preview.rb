# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/welcome_message
  def welcome_message
    UserMailer.with(user: user).welcome_message
  end

  private

  def user
    User.new(first_name: 'Jane', last_name: 'Doe', email: 'jane.doe@noesya.coop')
  end

end