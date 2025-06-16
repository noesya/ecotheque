# == Schema Information
#
# Table name: regions
#
#  id           :uuid             not null, primary key
#  description  :text
#  image_alt    :string
#  image_credit :string
#  name         :string
#  slug         :string           indexed
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_regions_on_slug  (slug) UNIQUE
#
class Region < ApplicationRecord
  include Slugged

  has_and_belongs_to_many :actors
  has_and_belongs_to_many :materials
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :technics

  has_one_attached_deletable :image

  validates_presence_of :name

  scope :published, -> {
    base_scope = left_joins(:actors, :materials, :projects)
    base_scope.merge(Actor.published)
      .or(base_scope.merge(Material.published))
      .or(base_scope.merge(Project.published))
      .distinct
  }

  scope :ordered, -> { order(:name) }

  scope :autofilter, -> (parameters) { ::Filters::Autofilter.new(self, parameters).filter }
  scope :autofilter_search, -> (term) {
    where("unaccent(regions.name) ILIKE unaccent(:term)", term: "%#{sanitize_sql_like(term)}%")
  }

  def to_s
    "#{name}"
  end
end
