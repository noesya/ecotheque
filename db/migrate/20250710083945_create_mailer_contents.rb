class CreateMailerContents < ActiveRecord::Migration[8.0]
  def change
    create_table :mailer_contents, id: :uuid do |t|
      t.string "identifier"
      t.string "subject"
      t.text "body"
      t.boolean "published", default: false
      t.timestamps
    end
  end
end