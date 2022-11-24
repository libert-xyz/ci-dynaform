class ChangeColumnDynaFormsUserIdFromStringToUuid < ActiveRecord::Migration[6.0]
  def change
    add_column :dyna_forms, :user_id_2, :uuid

    DynaForm.all.each do |df|
      df.update!(user_id_2: df.user_id)
    end
    remove_column :dyna_forms, :user_id

    rename_column :dyna_forms, :user_id_2, :user_id
  end
end
