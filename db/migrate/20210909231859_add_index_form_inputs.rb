class AddIndexFormInputs < ActiveRecord::Migration[6.0]
  def change
    add_index :form_inputs, :user_form_id
  end
end
