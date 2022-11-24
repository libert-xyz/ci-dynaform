class AlterSubmittedFormsAddColumnCompleteBit < ActiveRecord::Migration[6.0]
  def change
    add_column :submitted_forms, :completed, :boolean, default: false
  end
end
