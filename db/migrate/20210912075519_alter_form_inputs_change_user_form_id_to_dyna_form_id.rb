class AlterFormInputsChangeUserFormIdToDynaFormId < ActiveRecord::Migration[6.0]
  def change
    rename_column :form_inputs, :user_form_id, :dyna_form_id

    add_index :form_inputs, :dyna_form_id
  end
end
