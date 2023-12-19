# == Schema Information
#
# Table name: materials
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string
#  slug        :string           indexed
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  region_id   :uuid             indexed
#
# Indexes
#
#  index_materials_on_region_id  (region_id)
#  index_materials_on_slug       (slug)
#
class Material < ApplicationRecord
  include WithSlug
  include WithStructure

  belongs_to :region, optional: true
  
  scope :for_search_term, -> (term) {
    where("unaccent(materials.name) ILIKE unaccent(:term)", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :ordered, -> { order(:name) }

  validates_presence_of :name

  has_one_attached_deletable :image

  def to_s
    "#{name}"
  end
end
