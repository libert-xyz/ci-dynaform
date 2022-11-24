require 'rails_helper'

RSpec.describe InputType, type: :model do
  before(:all) do
    @user = FactoryBot.create(:user)
    @dyna_form = FactoryBot.create(:dyna_form, creator: @user)
    @text_input = FactoryBot.create(:form_input, :required, dyna_form: @dyna_form)
    @email_input = FactoryBot.create(:form_input, :email, dyna_form: @dyna_form)
    @required_email_input = FactoryBot.create(:form_input, :email, :required, dyna_form: @dyna_form)
    @phone_input = FactoryBot.create(:form_input, :phone_number, :required, dyna_form: @dyna_form)
    @submitted_form = FactoryBot.create(:submitted_form, dyna_form: @dyna_form)
    @submitted_text_response = SubmittedFormResponse.new(form_input: @text_input, submitted_form: @submitted_form)
    @submitted_email_response = SubmittedFormResponse.new(form_input: @email_input, value: "rspec@", submitted_form: @submitted_form)
    @submitted_blank_email_response = SubmittedFormResponse.new(form_input: @email_input, value: "", submitted_form: @submitted_form)
    @submitted_required_email_response = SubmittedFormResponse.new(form_input: @required_email_input, value: "rspec@", submitted_form: @submitted_form)
    @submitted_phone_number_response = SubmittedFormResponse.new(form_input: @phone_input, value: "234-555-1230", submitted_form: @submitted_form)
  end

  describe 'validations' do
    context 'required' do
      it 'should not be valid when the value is empty' do
        expect(@submitted_text_response.is_dyna_form_valid?).to be false
      end

      it 'should be valid when it is not empty' do
        @submitted_text_response.value = 'hello world'
        @submitted_text_response.errors.clear
        expect(@submitted_text_response.is_dyna_form_valid?).to be true
      end
    end

    context 'email' do
      it 'should not be valid when the value is not empty and not required' do
        expect(@submitted_email_response.is_dyna_form_valid?).to be false
      end

      it 'should be valid when the value is empty and not required' do
        expect(@submitted_blank_email_response.is_dyna_form_valid?).to be true
      end

      it 'should not be valid when the value is empty and required' do
        expect(@submitted_required_email_response.is_dyna_form_valid?).to be false
      end

      it 'should be valid when it is not empty' do
        @submitted_required_email_response.value = 'rspec@factory.com'
        @submitted_required_email_response.errors.clear
        expect(@submitted_required_email_response.is_dyna_form_valid?).to be true
      end
    end

    context 'phone number' do
      it 'should not be valid when the contains non-numeric values' do
        expect(@submitted_phone_number_response.is_dyna_form_valid?).to be false
      end

      it 'should not be valid the length is incorrect' do
        @submitted_phone_number_response.value = '123456789'
        @submitted_phone_number_response.errors.clear
        expect(@submitted_phone_number_response.is_dyna_form_valid?).to be false
      end

      it 'should not be valid the length is incorrect' do
        @submitted_phone_number_response.value = '1234567890'
        @submitted_phone_number_response.errors.clear
        expect(@submitted_phone_number_response.is_dyna_form_valid?).to be true
      end
    end

    context 'saving' do
      before(:each) do
        @submitted_phone_number_response.errors.clear
        @submitted_phone_number_response.value = '123456789'
      end

      it 'should save the data' do
        expect(@submitted_phone_number_response.save).to be true
      end

      it 'should contain record errors' do
        @submitted_phone_number_response.save
        expect(@submitted_phone_number_response.errors.full_messages).to be_present
      end

      it 'should persist the data' do
        @submitted_phone_number_response.value = '1234'
        @submitted_phone_number_response.save
        expect(@submitted_phone_number_response.value).to eq '1234'
      end
    end
  end
end
