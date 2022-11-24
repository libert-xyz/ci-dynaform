class AddColumnSubmittedFormsCompleteDateTimestamp < ActiveRecord::Migration[6.0]
  def change
    add_column :submitted_forms, :complete_date, :timestamp
  end
end
