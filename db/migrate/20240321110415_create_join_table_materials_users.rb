class CreateJoinTableMaterialsUsers < ActiveRecord::Migration[7.1]
  def change
    create_join_table :materials, :users, column_options: {type: :uuid} do |t|
      t.index [:material_id, :user_id]
    end

    Material.where.not(published_by_id: nil).each do |material|
      material.authors << User.find(material.published_by_id)
    end

  end
end
