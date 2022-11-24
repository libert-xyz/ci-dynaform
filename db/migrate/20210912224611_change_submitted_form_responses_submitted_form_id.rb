class ChangeSubmittedFormResponsesSubmittedFormId < ActiveRecord::Migration[6.0]
  def change
    add_column :submitted_form_responses, :submitted_form_id_2, :uuid

    SubmittedFormResponse.all.each do |sfr|
      sfr.update!(submitted_form_id_2: sfr.submitted_form_id)
    end
    remove_index :submitted_form_responses, name: :index_submitted_form_responses_on_submitted_form_id
    remove_column :submitted_form_responses, :submitted_form_id

    rename_column :submitted_form_responses, :submitted_form_id_2, :submitted_form_id
    add_index :submitted_form_responses, :submitted_form_id
  end
end
