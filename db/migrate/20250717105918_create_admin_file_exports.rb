class CreateAdminFileExports < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_file_exports, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.uuid "uuid", null: false
      t.datetime "expires_at", null: false
      t.timestamps
    end
  end
end
