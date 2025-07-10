module User::WithAuthentication
  extend ActiveSupport::Concern

  included do
    devise  :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
            :timeoutable, :trackable, :lockable, :confirmable, :two_factor_authenticatable

    has_one_time_password(encrypted: true)

    attr_accessor :accepts_terms_of_service

    validates_presence_of :first_name, :last_name, :email, :role
    validate :password_complexity
    validates :mobile_phone, format: { with: /\A\+[0-9]+\z/ }, allow_blank: true
    validates_acceptance_of :accepts_terms_of_service, on: :create

    before_validation :adjust_mobile_phone, :sanitize_fields
    after_create :send_welcome_message

    # Inject a session_token in user salt to prevent Cookie session hijacking
    # https://makandracards.com/makandra/53562-devise-invalidating-all-sessions-for-a-user
    def authenticatable_salt
      "#{super}#{session_token}"
    end

    def invalidate_all_sessions!
      self.session_token = SecureRandom.hex
    end

    def need_two_factor_authentication?(request)
      !visitor?
    end

    def direct_otp_default_delivery_method
      mobile_phone.present? ? :mobile_phone : :email
    end

    def send_two_factor_authentication_code(code, delivery_method)
      case delivery_method
      when :mobile_phone
        Brevo::SmsService.send_mfa_code(self, code)
      when :email
        send_devise_notification(:two_factor_authentication_code, code, {})
      end
    end

    def unlock_mfa!
      self.update_column(:second_factor_attempts_count, 0)
    end

    private

    def adjust_mobile_phone
      return if self.mobile_phone.blank?
      self.mobile_phone = MobilePhoneCleaner.clean(self.mobile_phone)
    end

    def sanitize_fields
      full_sanitizer = Rails::Html::FullSanitizer.new

      # Only text allowed, and remove '=' to prevent excel formulas
      self.email = full_sanitizer.sanitize(self.email)&.gsub('=', '')
      self.first_name = full_sanitizer.sanitize(self.first_name)&.gsub('=', '')
      self.last_name = full_sanitizer.sanitize(self.last_name)&.gsub('=', '')
      self.mobile_phone = full_sanitizer.sanitize(self.mobile_phone)&.gsub('=', '')
    end

    def password_complexity
      # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
      return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#{Rails.application.config.allowed_special_chars}]).{#{Devise.password_length.first},#{Devise.password_length.last}}$/
      errors.add :password, :password_strength
    end

    def send_welcome_message
      UserMailer.with(user: self).welcome_message.deliver_later 
    end

  end
end
