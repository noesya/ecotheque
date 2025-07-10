# == Schema Information
#
# Table name: mailer_contents
#
#  id         :uuid             not null, primary key
#  body       :text
#  identifier :string
#  published  :boolean          default(FALSE)
#  subject    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class MailerContent < ApplicationRecord

  scope :ordered, -> { order(:identifier) }

  validates :subject, :body, presence: true

  def to_s
    "#{identifier.humanize}"
  end

end
