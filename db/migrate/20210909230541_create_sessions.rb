class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions, id: :uuid do |t|
      t.string :user_id
      t.timestamp :expires_at
      t.timestamps
    end
  end
end
