# == Schema Information
#
# Table name: subscriptions
#
#  id                                   :uuid             not null, primary key
#  helloasso_checkout_intent_identifier :bigint
#  helloasso_order_identifier           :bigint
#  paid_amount                          :decimal(, )
#  paid_at                              :datetime
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  product_id                           :uuid             not null, indexed
#  user_id                              :uuid             not null, indexed
#
# Indexes
#
#  index_subscriptions_on_product_id  (product_id)
#  index_subscriptions_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_52a3b81fce  (product_id => products.id)
#  fk_rails_933bdff476  (user_id => users.id)
#
class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :product

  after_commit :update_user_role, on: :create

  scope :active, -> { where('paid_at >= ?', 1.year.ago) }
  scope :ordered, -> { order(created_at: :desc) }

  def update_user_role
    user.update_role_from_subscriptions!
  end

  def reference
    "##{helloasso_order_identifier}"
  end

  def to_s
    "#{reference} - #{user} - #{product}"
  end
end
