class RemoveProductsAndSubscriptions < ActiveRecord::Migration[7.2]
  def change
    drop_table :subscriptions
    drop_table :products
  end
end
