class ChangeSubmittedFormsDynaFormIdToUuid < ActiveRecord::Migration[6.0]
  def change
    add_column :submitted_forms, :dyna_form_id_2, :uuid

    SubmittedForm.all.each do |sf|
      sf.update!(dyna_form_id_2: sf.dyna_form_id)
    end
    remove_index :submitted_forms, name: :index_submitted_forms_on_dyna_form_id
    remove_column :submitted_forms, :dyna_form_id

    rename_column :submitted_forms, :dyna_form_id_2, :dyna_form_id
    add_index :submitted_forms, :dyna_form_id
  end
end
