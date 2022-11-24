class DropUserFormIndexes < ActiveRecord::Migration[6.0]
  def change
    remove_index "form_inputs", name: "index_form_inputs_on_user_form_id"
    remove_index "submitted_forms", name: "index_submitted_forms_on_user_form_id"
  end
end
