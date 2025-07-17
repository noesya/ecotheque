# == Schema Information
#
# Table name: users
#
#  id                            :uuid             not null, primary key
#  allow_listing                 :boolean          default(TRUE)
#  confirmation_sent_at          :datetime
#  confirmation_token            :string           uniquely indexed
#  confirmed_at                  :datetime
#  current_sign_in_at            :datetime
#  current_sign_in_ip            :string
#  description                   :text
#  direct_otp                    :string
#  direct_otp_delivery_method    :string
#  direct_otp_sent_at            :datetime
#  email                         :string           default(""), not null, uniquely indexed
#  encrypted_otp_secret_key      :string           uniquely indexed
#  encrypted_otp_secret_key_iv   :string
#  encrypted_otp_secret_key_salt :string
#  encrypted_password            :string           default(""), not null
#  failed_attempts               :integer          default(0), not null
#  first_name                    :string
#  last_name                     :string
#  last_sign_in_at               :datetime
#  last_sign_in_ip               :string
#  locked_at                     :datetime
#  mobile_phone                  :string
#  remember_created_at           :datetime
#  reset_password_sent_at        :datetime
#  reset_password_token          :string           uniquely indexed
#  role                          :integer          default("visitor"), not null
#  second_factor_attempts_count  :integer          default(0)
#  session_token                 :string
#  sign_in_count                 :integer          default(0), not null
#  totp_timestamp                :datetime
#  unconfirmed_email             :string
#  unlock_token                  :string           uniquely indexed
#  website                       :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token        (confirmation_token) UNIQUE
#  index_users_on_email                     (email) UNIQUE
#  index_users_on_encrypted_otp_secret_key  (encrypted_otp_secret_key) UNIQUE
#  index_users_on_reset_password_token      (reset_password_token) UNIQUE
#  index_users_on_unlock_token              (unlock_token) UNIQUE
#
class User < ApplicationRecord
  include WithAuthentication
  include WithRoles

  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :logs, dependent: :nullify
  has_many :file_exports, class_name: 'Admin::FileExport', dependent: :destroy

  has_and_belongs_to_many :projects
  has_and_belongs_to_many :technics
  has_and_belongs_to_many :materials
  has_and_belongs_to_many :actors

  has_one_attached_deletable :image

  scope :ordered, -> { order(:last_name, :first_name) }
  scope :ordered_by_date, -> { order(created_at: :desc) }
  scope :allowing_listing, -> { where(allow_listing: true) }

  scope :autofilter, -> (parameters) { ::Filters::Autofilter.new(self, parameters).filter }
  scope :autofilter_role, -> (role) { where(role: role) }
  scope :autofilter_search, -> (term) {
    where("
      unaccent(concat(users.first_name, ' ', users.last_name)) ILIKE unaccent(:term) OR
      unaccent(concat(users.last_name, ' ', users.first_name)) ILIKE unaccent(:term) OR
      unaccent(users.first_name) ILIKE unaccent(:term) OR
      unaccent(users.last_name) ILIKE unaccent(:term) OR
      unaccent(users.email) ILIKE unaccent(:term) OR
      unaccent(users.mobile_phone) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def in_favorites?(about)
    favorites.for_about(about).any?
  end

  def to_s
    first_name.present? ? "#{first_name} #{last_name}"
                        : "#{email}"
  end

  def name
    "#{first_name} #{last_name}"
  end

end
