# == Schema Information
#
# Table name: criterions
#
#  id          :uuid             not null, primary key
#  about_class :string
#  hint        :text
#  kind        :integer          default("string")
#  name        :string
#  position    :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Criterion < ApplicationRecord
  ABOUT_CLASSES = [
    Material
  ]

  has_many :values

  scope :ordered, -> { order(:position) }

  enum kind: {
    string: 0,
    text: 1,
  }, _prefix: :kind

  def to_s
    "#{name}"
  end
end
