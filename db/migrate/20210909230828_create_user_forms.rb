class CreateUserForms < ActiveRecord::Migration[6.0]
  def change
    create_table :user_forms, id: :uuid do |t|
      t.string :user_id
      t.string :title
      t.text :description
      t.boolean :published, default: false
      t.boolean :editable, default: true

      t.timestamps
    end
  end
end
