class AddIndexSessions < ActiveRecord::Migration[6.0]
  def change
    add_index :sessions, :user_id
  end
end
