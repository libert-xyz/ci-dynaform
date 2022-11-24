FactoryBot.define do
  factory :form_input do
    label 'Factory form input label'
    helper_text 'Lorem ipsum'
    input_type_id InputType.find_by(label: "Text").id

    trait :textarea do
      input_type_id {InputType.find_by(label: "Text Area").id}
    end

    trait :option_select do
      input_type_id {InputType.find_by(label: "Option Select").id}
    end

    trait :checkbox do
      input_type_id {InputType.find_by(label: "Checkbox").id}
    end

    trait :email do
      input_type_id {InputType.find_by(label: "Email").id}
    end

    trait :phone_number do
      input_type_id {InputType.find_by(label: "Phone Number").id}
    end

    trait :required do
      required {true}
    end
  end
end