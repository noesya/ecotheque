# == Schema Information
#
# Table name: admin_file_exports
#
#  id         :uuid             not null, primary key
#  expires_at :datetime         not null
#  uuid       :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null, indexed
#
# Indexes
#
#  index_admin_file_exports_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_7262291e7a  (user_id => users.id)
#
class Admin::FileExport < ApplicationRecord
  self.table_name = "admin_file_exports"

  EXPIRES_IN = 12.hours

  belongs_to :user
  has_one_attached :file

  validates :uuid, presence: true, uniqueness: true

  before_validation :set_uuid, :set_expires_at, on: :create

  def to_param
    uuid
  end

  protected

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def set_expires_at
    self.expires_at = EXPIRES_IN.from_now
  end
end
