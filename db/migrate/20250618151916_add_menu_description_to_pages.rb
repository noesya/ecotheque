class AddMenuDescriptionToPages < ActiveRecord::Migration[7.2]
  def change
    add_column :pages, :menu_description, :string
  end
end
