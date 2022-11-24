class CreateSubmittedForms < ActiveRecord::Migration[6.0]
  def change
    create_table :submitted_forms, id: :uuid do |t|
      t.string :user_form_id

      t.timestamps
    end
  end
end
