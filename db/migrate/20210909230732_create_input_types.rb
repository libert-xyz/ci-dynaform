class CreateInputTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :input_types, id: :uuid do |t|
      t.string :label
      t.string :ruby_klass

      t.timestamps
    end
  end
end
