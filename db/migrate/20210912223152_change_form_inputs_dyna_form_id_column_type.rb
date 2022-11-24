class ChangeFormInputsDynaFormIdColumnType < ActiveRecord::Migration[6.0]
  def change
    add_column :form_inputs, :dyna_form_id_2, :uuid

    FormInput.all.each do |fi|
      fi.update!(dyna_form_id_2: fi.dyna_form_id)
    end
    remove_index :form_inputs, name: :index_form_inputs_on_dyna_form_id

    remove_column :form_inputs, :dyna_form_id

    rename_column :form_inputs, :dyna_form_id_2, :dyna_form_id

    add_index :form_inputs, :dyna_form_id
  end
end
