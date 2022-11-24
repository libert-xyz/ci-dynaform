class ChangeSubmittedFormResponsesFormInputIdToUuid < ActiveRecord::Migration[6.0]
  def change
    add_column :submitted_form_responses, :form_input_id_2, :uuid

    SubmittedFormResponse.all.each do |sfr|
      sfr.update!(form_input_id_2: sfr.form_input_id)
    end
    remove_column :submitted_form_responses, :form_input_id

    rename_column :submitted_form_responses, :form_input_id_2, :form_input_id
  end
end
