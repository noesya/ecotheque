# == Schema Information
#
# Table name: actors
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  region_id   :uuid             indexed
#
# Indexes
#
#  index_actors_on_region_id  (region_id)
#
# Foreign Keys
#
#  fk_rails_a8de6705d8  (region_id => regions.id)
#
class Actor < ApplicationRecord
  include WithSlug
  include WithStructure

  belongs_to :region, optional: true
  has_many :materials
  
  has_one_attached_deletable :image

  validates_presence_of :name

  scope :ordered, -> { order(:name) }

  scope :autofilter, -> (parameters) { ::Filters::Autofilter.new(self, parameters).filter }
  scope :autofilter_search, -> (term) {
    where("unaccent(materials.name) ILIKE unaccent(:term)", term: "%#{sanitize_sql_like(term)}%")
  }

  def to_s
    "#{name}"
  end
end
