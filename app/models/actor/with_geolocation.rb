module Actor::WithGeolocation
  extend ActiveSupport::Concern

  included do
    geocoded_by :full_address_for_geocode, lookup: -> (actor) { actor.geocoder_lookup }

    after_validation :geocode, if: -> (geocodable) { geocodable.full_address_present? && geocodable.full_address_changed? }
  end

  def full_address_for_geocode
    "#{address}, #{zipcode} #{city} #{country}"
  end

  def full_address_present?
    address.present? || zipcode.present? || city.present?
  end

  def full_address_changed?
    address_changed? || zipcode_changed? || city_changed? || country_changed?
  end

  def geocoder_lookup
    # Use Base Adresse Nationale FR for French addresses, else Nominatim
    country == 'FR' ? :ban_data_gouv_fr
                    : :nominatim
  end
end