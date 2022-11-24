require 'rails_helper'

RSpec.describe SubmittedForm, type: :model do
  before(:all) do
    @user = FactoryBot.create(:user)
    @dyna_form = FactoryBot.create(:dyna_form, creator: @user)
    @text_input = FactoryBot.create(:form_input, :required, dyna_form: @dyna_form)
    @email_input = FactoryBot.create(:form_input, :email, dyna_form: @dyna_form)
    @phone_input = FactoryBot.create(:form_input, :phone_number, dyna_form: @dyna_form)
    @submitted_form = FactoryBot.create(:submitted_form, dyna_form: @dyna_form)
    @submitted_text_response = SubmittedFormResponse.create(form_input: @text_input, submitted_form: @submitted_form)
    @submitted_email_response = SubmittedFormResponse.create(form_input: @email_input, value: "rspec@", submitted_form: @submitted_form)
    @submitted_phone_number_response = SubmittedFormResponse.create(form_input: @phone_input, value: "234-555-1230", submitted_form: @submitted_form)
  end

  describe 'all_responses_valid' do
    before(:each) { allow(@submitted_form).to receive(:submitted_form_responses) { [@submitted_text_response, @submitted_phone_number_response, @submitted_email_response] } }

    context 'when all inputs are not valid' do
      it 'should be falsey' do
        @submitted_form.process_submissions
        expect(@submitted_form.all_responses_valid).to be false
      end
    end

    context 'when all inputs are valid' do
      before(:each) do
        @submitted_text_response.value = 'hello world'
        @submitted_text_response.errors.clear
        @submitted_email_response.value = 'rspec@factory.com'
        @submitted_email_response.errors.clear
        @submitted_phone_number_response.value = '1234567890'
        @submitted_phone_number_response.errors.clear
        @submitted_form.process_submissions
      end

      it 'should be truthy' do
        expect(@submitted_form.all_responses_valid).to be true
      end
    end
  end

  describe 'complete!' do
    context 'when all inputs are valid' do
      before(:each) do
        @submitted_text_response.value = 'hello world'
        @submitted_text_response.errors.clear
        @submitted_email_response.value = 'rspec@factory.com'
        @submitted_email_response.errors.clear
        @submitted_phone_number_response.value = '1234567890'
        @submitted_phone_number_response.errors.clear
        allow(@submitted_form).to receive(:submitted_form_responses) { [@submitted_text_response, @submitted_phone_number_response, @submitted_email_response] }
        @submitted_form.process_submissions
      end

      it 'should set the date' do
        @submitted_form.complete
        @submitted_form.reload
        expect(@submitted_form.complete_date).to_not be nil
      end

      it 'should not attempt to update the record when called again' do
        expect(@submitted_form).to_not receive(:update)
        @submitted_form.complete
      end
    end
  end
end
