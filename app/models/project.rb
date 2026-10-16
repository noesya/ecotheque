# == Schema Information
#
# Table name: projects
#
#  id           :uuid             not null, primary key
#  description  :text
#  image_alt    :string
#  image_credit :string
#  name         :string
#  published    :boolean          default(FALSE)
#  slug         :string           uniquely indexed
#  sources      :text
#  status       :integer          default("draft")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_projects_on_slug  (slug) UNIQUE
#
class Project < ApplicationRecord
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
  has_and_belongs_to_many :materials
  has_and_belongs_to_many :technics
  has_and_belongs_to_many :authors, class_name: 'User', join_table: "projects_users", association_foreign_key: :user_id

  has_many  :answers, dependent: :destroy
  accepts_nested_attributes_for :answers
  has_many  :criterions,
            -> { where('project_answers.value IS TRUE') },
            through: :answers

  has_one_attached_deletable :image

  attr_accessor :acceptance

  validates_presence_of :name
  validates_acceptance_of :acceptance, on: :create

  scope :autofilter, -> (parameters) { ::Filters::Autofilter.new(self, parameters).filter }
  scope :autofilter_search, -> (term) {
    where("unaccent(projects.name) ILIKE unaccent(:term)", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :autofilter_published, -> (status) { where(published: status) }

  def has_brezet_wheel?
    answers.where(value: true).exists?
  end

  def to_s
    "#{name}"
  end

  protected

  def search_data
    {
      name: name,
      description: description,
      published: published,
      structure_values: searchable_text_from_structure_values,
      answers: searchable_text_from_answers
    }
  end

  def searchable_text_from_answers
    raw_texts_from_answers = answers.where(value: true).pluck(:text).compact
    CustomSanitizer.sanitize(raw_texts_from_answers.join(' '), 'string')
  end
end
