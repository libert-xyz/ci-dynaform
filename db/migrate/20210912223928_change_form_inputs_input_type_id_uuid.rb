class ChangeFormInputsInputTypeIdUuid < ActiveRecord::Migration[6.0]
  def change
    add_column :form_inputs, :input_type_id_2, :uuid

    FormInput.all.each do |fi|
      fi.update!(input_type_id_2: fi.input_type_id)
    end
    remove_column :form_inputs, :input_type_id

    rename_column :form_inputs, :input_type_id_2, :input_type_id
  end
end
