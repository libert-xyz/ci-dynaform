class AlterInputTypesAddDisplayOrderAsInteger < ActiveRecord::Migration[6.0]
  def change
    add_column :input_types, :display_order, :integer

    InputType.find_by(label: "Text")&.update!(display_order: 1)
    InputType.find_by(label: "Text Area")&.update!(display_order: 2)
    InputType.find_by(label: "Email")&.update!(display_order: 3)
    InputType.find_by(label: "Phone Number")&.update!(display_order: 4)
    InputType.find_by(label: "Option Select")&.update!(display_order: 5)
    InputType.find_by(label: "Checkbox")&.update!(display_order: 6)
  end
end
