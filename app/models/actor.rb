# == Schema Information
#
# Table name: actors
#
#  id                    :uuid             not null, primary key
#  address               :string
#  address_additional    :string
#  city                  :string
#  contact_email         :string
#  contact_inventory_url :string
#  contact_name          :string
#  contact_phone         :string
#  contact_website       :string
#  country               :string
#  description           :text
#  image_alt             :string
#  image_credit          :string
#  latitude              :decimal(, )
#  longitude             :decimal(, )
#  name                  :string
#  premium               :boolean          default(FALSE)
#  published             :boolean          default(FALSE)
#  service_access_terms  :text
#  slug                  :string
#  sources               :text
#  status                :integer          default("draft")
#  zipcode               :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class Actor < ApplicationRecord
  include Commentable
  include Favoritable
  include Loggable
  include Orderable
  include Publishable
  include Regional
  include Searchable
  include Slugged
  include Structured
  include WithGeolocation

  has_and_belongs_to_many :materials
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :technics
  has_and_belongs_to_many :authors, class_name: 'User', join_table: "actors_users", association_foreign_key: :user_id

  has_one_attached_deletable :image
  has_one_attached_deletable :logo

  validates_presence_of :name

  scope :premium, -> { where(premium: true) }
  scope :with_contact_informations, -> { where.not(contact_name: [nil, ''], contact_email: [nil, ''], contact_phone: [nil, ''], contact_website: [nil, ''], contact_inventory_url: [nil, '']) }

  scope :autofilter, -> (parameters) { ::Filters::Autofilter.new(self, parameters).filter }
  scope :autofilter_search, -> (term) {
    where("unaccent(actors.name) ILIKE unaccent(:term)", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :autofilter_published, -> (status) { where(published: status) }
  scope :autofilter_premium, -> (status) { where(premium: status) }

  def full_address
    @full_address ||= [address, address_additional, city, zipcode, country].compact_blank.join(', ')
  end

  def has_any_contact_informations?
    # match with_contact_informations scope
    contact_name.present? ||
      contact_email.present? ||
      contact_phone.present? ||
      contact_website.present? ||
      contact_inventory_url.present? 
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
      full_address: full_address,
      contact_email: contact_email,
      contact_inventory_url: contact_inventory_url,
      contact_name: contact_name,
      contact_phone: contact_phone,
      contact_website: contact_website,
      service_access_terms: service_access_terms,
      structure_values: searchable_text_from_structure_values
    }
  end
end
