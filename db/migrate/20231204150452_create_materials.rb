class CreateMaterials < ActiveRecord::Migration[7.1]
  def change
    create_table :materials, id: :uuid do |t|
      t.string :name
      t.string :slug
      t.text :description

      t.timestamps
    end
  end
end
