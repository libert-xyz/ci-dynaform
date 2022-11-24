class AlterDynaFormsSetLockedToFalse < ActiveRecord::Migration[6.0]
  def change
    ActiveRecord::Base.connection.execute("
      update dyna_forms
      set locked = case when locked then false else true end
    ")
  end
end
