class RenameUserFormsTableToDynaFormsTable < ActiveRecord::Migration[6.0]
  def change
    rename_table :user_forms, :dyna_forms
  end
end
