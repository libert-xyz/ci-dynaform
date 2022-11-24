class CreateFormInputs < ActiveRecord::Migration[6.0]
  def change
    create_table :form_inputs, id: :uuid do |t|
      t.string :label
      t.string :helper_text
      t.string :user_form_id
      t.string :input_type_id
      t.integer :display_order
      t.boolean :required, default: false
      t.text :additional_attributes

      t.timestamps
    end
  end
end
