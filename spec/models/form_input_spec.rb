require 'rails_helper'

RSpec.describe FormInput, type: :model do
  before(:all) do
    @user = FactoryBot.create(:user)
    @dyna_form = FactoryBot.create(:dyna_form, creator: @user)
    input_type = InputType.first
    @first_form_input = FormInput.create(label: 'test 1', dyna_form: @dyna_form, input_type: input_type)
    @second_form_input = FormInput.create(label: 'test 2', dyna_form: @dyna_form, input_type: input_type)
  end

  context 'display_order' do
    it 'should properly set the display_order' do
      expect(@first_form_input.display_order).to eq 1
      expect(@second_form_input.display_order).to eq 2
    end
  end
end
