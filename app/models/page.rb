# == Schema Information
#
# Table name: pages
#
#  id                  :uuid             not null, primary key
#  ancestor_kind       :integer          default("neutral")
#  body_class          :string           default("")
#  description         :text
#  internal_identifier :string
#  meta_description    :text
#  meta_title          :string
#  name                :string           not null
#  path                :string           not null
#  position            :integer
#  slug                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  parent_id           :uuid             indexed
#
# Indexes
#
#  index_pages_on_parent_id  (parent_id)
#
# Foreign Keys
#
#  fk_rails_409bbac70a  (parent_id => pages.id)
#
class Page < ApplicationRecord

  HOME_INTERNAL_IDENTIFIER = 'home'.freeze
  LAB_INTERNAL_IDENTIFIER = 'le-lab'.freeze
  TOOLBOX_INTERNAL_IDENTIFIER = 'boite-a-outils'.freeze
  DONATION_INTERNAL_IDENTIFIER = 'donation'.freeze

  include Loggable
  include Searchable
  include Slugged
  include WithTree

  enum :ancestor_kind, { neutral: 0, lab: 10, toolbox: 20 }

  has_many :blocks, dependent: :destroy
  belongs_to :parent, class_name: 'Page', optional: true
  has_many :children, class_name: 'Page', foreign_key: :parent_id, dependent: :destroy

  has_one_attached_deletable :meta_illustration

  validates :name, presence: true

  before_validation :set_body_class, :set_path, :set_ancestor_kind
  after_save :update_children_paths, if: :saved_change_to_path?

  scope :ordered, -> { order(:name) }
  scope :ordered_by_position, -> { order(:position, :name) }

  scope :autofilter, -> (parameters) { ::Filters::Autofilter.new(self, parameters).filter }
  scope :autofilter_search, -> (term) {
    where("unaccent(pages.name) ILIKE unaccent(:term)", term: "%#{sanitize_sql_like(term)}%")
  }

  def self.lab
    @@lab ||= find_by(internal_identifier: LAB_INTERNAL_IDENTIFIER)
  end

  def self.toolbox
    @@toolbox ||= find_by(internal_identifier: TOOLBOX_INTERNAL_IDENTIFIER)
  end

  def generated_path
    ancestors.any? ? "#{ancestors.pluck(:slug).join('/')}/#{slug}"
                   : slug
  end

  def is_lab?
    internal_identifier == LAB_INTERNAL_IDENTIFIER
  end

  def is_donation?
    internal_identifier == DONATION_INTERNAL_IDENTIFIER
  end

  def to_s
    "#{name}"
  end

  def to_param
    id
  end

  private

  def set_body_class
    self.body_class = 'toolbox-index' if internal_identifier == TOOLBOX_INTERNAL_IDENTIFIER
    self.body_class = 'laboratory-index' if internal_identifier == LAB_INTERNAL_IDENTIFIER
    self.body_class = 'donation-show' if internal_identifier == DONATION_INTERNAL_IDENTIFIER
    self.body_class = 'toolbox-child' if ancestors.pluck(:internal_identifier).include?(TOOLBOX_INTERNAL_IDENTIFIER)
    self.body_class = 'laboratory-child' if ancestors.pluck(:internal_identifier).include?(LAB_INTERNAL_IDENTIFIER)
  end

  def set_path
    self.path = generated_path
  end

  def update_children_paths
    descendants.each do |child|
      child.update_column :path, child.generated_path
    end
  end

  def set_ancestor_kind
    if ancestors_and_self.detect { |ancestor| ancestor == Page.lab }
      self.ancestor_kind = 'lab'
    elsif ancestors_and_self.detect { |ancestor| ancestor == Page.toolbox }
      self.ancestor_kind = 'toolbox'
    else
      self.ancestor_kind = 'neutral'
    end
  end

  def search_data
    {
      name: name,
      description: description,
      blocks: searchable_text_from_blocks,
      ancestor_kind: ancestor_kind
    }
  end

  def searchable_text_from_blocks
    blocks.pluck(:searchable_text_from_data).compact.join(' ')
  end

end
