class AlterDynaFormsEditableColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :dyna_forms, :editable, :locked

    change_column_default :dyna_forms, :locked, false
  end
end
