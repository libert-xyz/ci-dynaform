class AlterSubmittedFormsChangeUserFormIdToDynaFormId < ActiveRecord::Migration[6.0]
  def change
    rename_column :submitted_forms, :user_form_id, :dyna_form_id

    add_index :submitted_forms, :dyna_form_id
  end
end
