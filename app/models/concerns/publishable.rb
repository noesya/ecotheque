module Publishable
  extend ActiveSupport::Concern

  included do
    enum :status, {
      draft: 0,
      # waiting_for_attribution: 20,
      missing_informations: 40,
      redaction_in_progress: 30,
      waiting_for_approval: 50,
      ready_for_publication: 80,
      validated: 60,
      manufacturer: 70,
      rejected: 10
    }, prefix: :status

    scope :published, -> { where(published: true) }
    scope :draft, -> { where(published: false) }
    scope :autofilter_status, -> (status) { where(status: status) }
  end

end
