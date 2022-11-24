class AddValidatesToInputTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :input_types, :validates, :string
  end
end
