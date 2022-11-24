class CreateSubmittedFormResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :submitted_form_responses, id: :uuid do |t|
      t.string :submitted_form_id
      t.string :form_input_id
      t.text :value
      t.string :additional_data

      t.timestamps
    end
  end
end
