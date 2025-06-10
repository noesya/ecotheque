class AddBodyClassToPages < ActiveRecord::Migration[7.1]
  def change
    add_column :pages, :body_class, :string, default: ''
    Page.find_each(&:save)
  end
end
