# == Schema Information
#
# Table name: technics
#
#  id           :uuid             not null, primary key
#  description  :text
#  image_alt    :string
#  image_credit :string
#  name         :string
#  published    :boolean          default(FALSE)
#  slug         :string
#  sources      :text
#  status       :integer          default("draft")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Technic < ApplicationRecord
  include Commentable
  include Favoritable
  include Loggable
  include Orderable
  include Publishable
  include Regional
  include Searchable
  include Slugged
  include Structured

  has_and_belongs_to_many :actors
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :authors, class_name: 'User', join_table: "technics_users", association_foreign_key: :user_id

  has_one_attached_deletable :image

  validates_presence_of :name

  scope :autofilter, -> (parameters) { ::Filters::Autofilter.new(self, parameters).filter }
  scope :autofilter_search, -> (term) {
    where("unaccent(technics.name) ILIKE unaccent(:term)", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :autofilter_published, -> (status) { where(published: status) }

  def to_s
    "#{name}"
  end

  protected

  def search_data
    {
      name: name,
      description: description,
      published: published,
      structure_values: searchable_text_from_structure_values
    }
  end
end
