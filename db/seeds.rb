# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

InputType.create!(label: 'Text', short_description: 'A small text field', ruby_klass: 'Text', display_order: 1)
InputType.create!(label: 'Text Area', short_description: 'A large text area', ruby_klass: 'TextArea', display_order: 2)
InputType.create!(label: 'Option Select', short_description: 'List of selectable options - only 1 can be selected', ruby_klass: 'OptionSelect', display_order: 3)
InputType.create!(label: 'Checkbox', short_description: 'List of selectable options - many can be selected', ruby_klass: 'Checkbox', display_order: 4)
InputType.create!(label: 'Email', short_description: 'Text field that validates email formatting', ruby_klass: 'Text', validates: JSON.pretty_generate({method: 'email'}), display_order: 5)
InputType.create!(label: 'Phone Number', short_description: 'Text field that validates and sanitizes the input', ruby_klass: 'Text', validates: JSON.pretty_generate({method: 'phone_number'}), display_order: 6)