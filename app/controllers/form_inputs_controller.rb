class FormInputsController < ApplicationController
  before_action :redirect_if_not_logged_in, :set_request_objects

  def create
    @form_input = FormInput.new(form_input_params)
    @form_input.dyna_form_id = params[:dyna_form_id]
    @submitted_form_response = SubmittedFormResponse.new(form_input: @form_input)
    respond_to do |format|
      if params[:sample]
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "new_form_input_sample",
            partial: "form_inputs/sample",
            locals: {form_input: @form_input, submitted_form_response: @submitted_form_response}
          )}
      elsif @form_input.save
        @form_input = FormInput.new(input_type_id: Current.ordered_input_types.first.id)
        @submitted_form_response = SubmittedFormResponse.new(form_input: @form_input)
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "new_form_input",
            partial: "form_inputs/form",
            locals: {form_input: @form_input, submitted_form_response: @submitted_form_response, dyna_form: @dyna_form}
          )}
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "new_form_input",
            partial: "form_inputs/form",
            locals: {form_input: @form_input, submitted_form_response: @submitted_form_response, dyna_form: @dyna_form}
          )}
      end
    end
  end

  def update
    @form_input.assign_attributes(form_input_params)
    @form_input.dyna_form_id = params[:dyna_form_id]
    respond_to do |format|
      if params[:sample]
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "form_input_#{@form_input.id}_sample",
            partial: "form_inputs/sample",
            locals: {form_input: @form_input, submitted_form_response: @submitted_form_response, editing: true}
          )}
      elsif @form_input.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "form_input_#{@form_input.id}",
            partial: "form_inputs/sample",
            locals: {form_input: @form_input, submitted_form_response: @submitted_form_response, dyna_form: @dyna_form}
          )}
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "form_input_#{@form_input.id}",
            partial: "form_inputs/form",
            locals: {form_input: @form_input, submitted_form_response: @submitted_form_response, dyna_form: @dyna_form, editing: true}
          )}
      end
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "form_input_#{@form_input.id}_sample",
          partial: "form_inputs/form",
          locals: {dyna_form: @form_input.dyna_form, form_input: @form_input, submitted_form_response: @submitted_form_response, editing: true}
        )
      }
    end
  end

  def destroy
    @form_input = Current.user.form_inputs.find(params[:id])
    @form_input.destroy
  end

  private
  def form_input_params
    params.require(:form_input).permit(:label, :helper_text, :input_type_id, :required, :additional_attributes, :display_order)
  end

  def set_request_objects
    @form_input = FormInput.find_by(id: params[:id])
    @dyna_form = DynaForm.find_by(id: params[:dyna_form_id])
    @submitted_form_response = SubmittedFormResponse.new(form_input: @form_input) if @form_input
  end
end