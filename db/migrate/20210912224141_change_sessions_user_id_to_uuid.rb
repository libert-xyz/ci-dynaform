class ChangeSessionsUserIdToUuid < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :user_id_2, :uuid

    Session.all.each do |session|
      session.update!(user_id_2: session.user_id)
    end
    remove_index :sessions, name: :index_sessions_on_user_id
    remove_column :sessions, :user_id

    rename_column :sessions, :user_id_2, :user_id
    add_index :sessions, :user_id
  end
end
