class CreateJoinTableActorsUsers < ActiveRecord::Migration[7.1]
  def change
    create_join_table :actors, :users, column_options: {type: :uuid} do |t|
      t.index [:actor_id, :user_id]
    end

    Actor.where.not(published_by_id: nil).each do |actor|
      actor.authors << User.find(actor.published_by_id)
    end

  end
end
