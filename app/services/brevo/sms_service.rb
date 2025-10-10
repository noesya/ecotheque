module Brevo
  class SmsService
    DEFAULT_SENDER_NAME = 'Ecotheque'.freeze

    def self.send_mfa_code(user, code)
      duration =  ActiveSupport::Duration.build(Rails.application.config.devise.direct_otp_valid_for).inspect
      message = "#{code} est votre code d'authentification (valide #{duration})"
      self.send_message(user, message)
    end

    private

    def self.send_message(user, message)
      api_instance = Brevo::TransactionalSMSApi.new
      send_transac_sms = Brevo::SendTransacSms.new(
        sender: DEFAULT_SENDER_NAME,
        recipient: user.mobile_phone,
        content: message
      )

      begin
        # Send SMS message to a mobile number
        result = api_instance.send_transac_sms(send_transac_sms)
        p result
      rescue Brevo::ApiError => e
        puts "Exception when calling TransactionalSMSApi->send_transac_sms: #{e}"
      end
    end
  end
end
