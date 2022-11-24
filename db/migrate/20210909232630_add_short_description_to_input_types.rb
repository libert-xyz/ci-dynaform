class AddShortDescriptionToInputTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :input_types, :short_description, :string
  end
end
