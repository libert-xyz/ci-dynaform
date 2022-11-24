class SubmittedFormsController < ApplicationController
  layout "application_no_nav"

  before_action :set_submitted_form, except: :build_survey

  def build_survey
    @dyna_form = DynaForm.published.find_by(id: params[:dyna_form_id])
    if Current.session&.user == @dyna_form.creator
      render json: {msg: "Sorry, creators are not permitted to take their own surveys no matter how awesome they might be. :-(", status: 404}
    elsif @dyna_form.present?
      @submitted_form = SubmittedForm.create!(dyna_form: @dyna_form)
      @form_responses = @dyna_form.form_inputs.order(:display_order).map { |form_input| SubmittedFormResponse.create!(submitted_form: @submitted_form, form_input: form_input) }
      render json: {submitted_form_id: @submitted_form.id, status: 204}
    else
      render json: {msg: "The requested survey could not be found. Perhaps the owner has unpublished it or the id is incorrect :-(", status: 404}
    end
  end

  def show
    @submitted_form = SubmittedForm.find(params[:id])
    @ordered_inputs = @submitted_form.submitted_form_responses.order(:created_at).preload(:form_input)
  end

  def save_progress
    with_validations = params["complete"].present?
    @submitted_form_responses = @submitted_form.submitted_form_responses
    @submitted_form_responses.each { |sfr| sfr.value = params[sfr.id] }
    @submitted_form.process_submissions(@submitted_form_responses, with_validations)
    if with_validations
      form_is_complete = @submitted_form.complete
      if form_is_complete
        respond_to do |format|
          format.turbo_stream {
            render turbo_stream: [
              turbo_stream.replace(@submitted_form,
                partial: "submitted_forms/submission_form",
                locals: {id: params[:id], ordered_inputs: @submitted_form.submitted_form_responses, completed: true}
              ),
              turbo_stream.replace(
                "flash_message",
                partial: "flash_message",
                locals: {message: "Survey complete. Thank you!", status: "success"}
              )
            ]
          }
        end
      else
        respond_to do |format|
          format.turbo_stream {
            render turbo_stream: [
              turbo_stream.replace(@submitted_form,
                partial: "submitted_forms/submission_form",
                locals: {id: params[:id], ordered_inputs: @submitted_form.submitted_form_responses}
              ),
              turbo_stream.replace(
                "flash_message",
                partial: "flash_message",
                locals: {message: "From could not be completed.", status: "error"}
              )
            ]
          }
        end

      end
    else
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@submitted_form,
              partial: "submitted_forms/submission_form",
              locals: {id: params[:id], ordered_inputs: @submitted_form.submitted_form_responses.preload(:form_input) }),
            turbo_stream.replace(
              "flash_message",
              partial: "flash_message",
              locals: {message: "Progress saved!", status: "success"}
            )
          ]
        }
      end
    end
  end

  private

  def set_submitted_form
    @submitted_form = SubmittedForm.find(params[:id])
  end
end
