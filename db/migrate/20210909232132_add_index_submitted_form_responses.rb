class AddIndexSubmittedFormResponses < ActiveRecord::Migration[6.0]
  def change
    add_index :submitted_form_responses, :submitted_form_id
  end
end
