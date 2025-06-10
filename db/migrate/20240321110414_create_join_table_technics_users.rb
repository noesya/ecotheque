class CreateJoinTableTechnicsUsers < ActiveRecord::Migration[7.1]
  def change
    create_join_table :technics, :users, column_options: {type: :uuid} do |t|
      t.index [:technic_id, :user_id]
    end

    Technic.where.not(published_by_id: nil).each do |technic|
      technic.authors << User.find(technic.published_by_id)
    end

  end
end
