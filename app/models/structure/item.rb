# == Schema Information
#
# Table name: structure_items
#
#  id               :uuid             not null, primary key
#  about_class      :string
#  color            :string
#  hint             :text
#  kind             :integer          default("string")
#  name             :string
#  position         :integer          default(0)
#  premium          :boolean          default(FALSE)
#  show_in_list     :boolean          default(FALSE)
#  show_label       :boolean          default(TRUE)
#  slug             :string
#  with_explanation :boolean          default(TRUE)
#  zone             :integer          default("page")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Structure::Item < ApplicationRecord
  include Positionable # last_ordered_element is overwritten
  include Slugged

  ABOUT_CLASSES = [
    Actor,
    Project,
    Material,
    Technic
  ]

  ABOUT_CLASSES_WITH_PREMIUM = [
    'Actor'
  ]

  KINDS_WITH_OPTIONS = [
    'option',
    'options',
    'colors'
  ]

  KINDS_ALLOWED_IN_LIST = [
    'option',
    'options'
  ]

  has_many :values, dependent: :destroy
  has_many :options, dependent: :destroy
  accepts_nested_attributes_for :options, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :name

  before_validation :force_hide_in_list, unless: :allowed_in_list?

  scope :with_options, -> { where(kind: Structure::Item::KINDS_WITH_OPTIONS) }
  scope :in_list, -> { where(show_in_list: true) }

  enum :kind, {
    string: 0,
    text: 1,
    richtext: 5,
    key_figure: 6,
    url: 2,
    option: 11,
    options: 12,
    colors: 13,
    file: 21,
    files: 22,
    images: 24,
    h2: 102,
    help: 900
  }, prefix: :kind

  enum :zone, {
    header: 2,
    page: 3,
    lower_page: 6
  }, prefix: :zone

  def has_options?
    kind.in?(Structure::Item::KINDS_WITH_OPTIONS)
  end

  def self.possible_zones_for(about_class)
    # zone lower_page is only for Project or Actor
    ['Project', 'Actor'].include?(about_class) ? Structure::Item.zones : Structure::Item.zones.reject { |k, v| k == "lower_page" }
  end

  def values_for(object)
    values.where(about: object)
  end

  def value_for(object)
    values_for(object).first_or_create
  end

  def text_for(object)
    value_for(object).text
  end

  def options_for(object)
    value_for(object).options.ordered
  end

  def option_for(object)
    options_for(object).first
  end

  def selected_option?(object, option)
    option.in? options_for(object)
  end

  def files_for(object)
    value_for(object).files.ordered
  end

  def file_for(object)
    files_for(object).first
  end

  def children
    return Structure::Item.none unless kind_h2?
    next_title ? next_siblings.where('position < ?', next_title.position)
                : next_siblings
  end

  def should_display_for?(object)
    # règles :
    # - si l'objet est un auteurice, que c'est un champ premium et que l'objet n'est pas premium, on masque
    return false if premium? && object.respond_to?(:premium) && !object.premium?
    # - si c'est un titre on affiche si au moins un des éléments suivants jusqu'au prochain titre est should_display? == true
    return true if kind_h2? && children.any? { |child| child.should_display_for?(object) }
    # - si c'est un critère à choix multiple, on affiche tout le temps
    return true if has_options?
    # - si c'est un autre critère on affiche si rempli
    text_for(object).present? || file_for(object)&.file&.attached?
  end

  def should_display_in_admin_for?(object)
    # règles :
    # - si l'objet est un auteurice, que c'est un champ premium et que l'objet n'est pas premium, on masque
    return false if premium? && object.respond_to?(:premium) && !object.premium?
    # - si c'est un titre et qu'aucun des enfants ne doit être affiché
    return false if kind_h2? && children.none? { |child| child.should_display_in_admin_for?(object) }
    # - sinon
    return true
  end

  def to_s
    "#{name}"
  end

  protected

  def last_ordered_element
    Structure::Item.where(about_class: about_class, zone: zone).ordered.last
  end

  def next_siblings
   @next_siblings ||= Structure::Item.where(about_class: about_class, zone: zone).where('position > ?', position).ordered
  end

  def next_title
    @next_title ||= next_siblings.kind_h2.first
  end

  def force_hide_in_list
    self.show_in_list = false
  end

  def allowed_in_list?
    kind.in?(Structure::Item::KINDS_ALLOWED_IN_LIST)
  end

end
