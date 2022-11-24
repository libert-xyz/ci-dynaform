class AddIndexSubmittedForms < ActiveRecord::Migration[6.0]
  def change
    add_index :submitted_forms, :user_form_id
  end
end
