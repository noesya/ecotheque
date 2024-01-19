class CreateActors < ActiveRecord::Migration[7.1]
  def change
    create_table :actors, id: :uuid do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.references :region, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
