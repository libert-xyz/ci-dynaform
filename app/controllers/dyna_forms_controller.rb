class DynaFormsController < ApplicationController
  before_action :redirect_if_not_logged_in, except: [:index, :published_surveys, :take_survey]
  before_action :set_dyna_form, except: [:index, :published_surveys, :new, :create]

  layout "application_no_nav", only: :take_survey
  # login_url
  def new
  end

  def details
    partial_path = @dyna_form.locked? ? "preview" : "dyna_form_with_inputs"
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "user_dyna_form_window",
          partial: "dyna_forms/#{partial_path}",
          locals: {dyna_form: @dyna_form}
        )}
    end
  end

  def take_survey
    @dyna_form = DynaForm.published.find_by(id: params[:id])
  end

  def published_surveys
    @dyna_forms = DynaForm.where(published: true)
  end

  def publish
    updateable = @dyna_form.form_inputs.any? && !@dyna_form.published
    respond_to do |format|
      format.turbo_stream do
        if updateable && @dyna_form.publish
          render turbo_stream: turbo_stream.replace(
            "flash_message",
            partial: "flash_message",
            locals: {message: "#{@dyna_form.title} has been published!", status: "success"}
          )
        else
          render turbo_stream: turbo_stream.replace(
            "flash_message",
            partial: "flash_message",
            locals: {message: "#{@dyna_form.title} cannot be published.", status: "error"}
          )
        end
      end
    end
  end

  def unpublish
    if @dyna_form.unpublish
      render turbo_stream: turbo_stream.replace(
        "flash_message",
        partial: "flash_message",
        locals: {message: "#{@dyna_form.title} has been unpublished.", status: "success"}
      )
    else
      render turbo_stream: turbo_stream.replace(
        "flash_message",
        partial: "flash_message",
        locals: {message: "#{@dyna_form.title} cannot be unpublished", status: "error"}
      )
    end
  end

  def results
    @submitted_data, @headers = @dyna_form.completed_pivot_table
    @pending_data, @headers = @dyna_form.pending_pivot_table
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "user_dyna_form_window",
          partial: "dyna_forms/results",
          locals: {submitted_data: @submitted_data, pending_data: @pending_data, headers: @headers}
        )
      end
    end
  end

  def create
    @dyna_form = Current.user.dyna_forms.new(dyna_form_params)
    respond_to do |format|
      if @dyna_form.save
        format.turbo_stream {render layout: false}
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            @dyna_form,
            partial: "dyna_forms/form",
            locals: {dyna_form: @dyna_form}
          )}
      end
    end
  end

  def destroy
    @dyna_form.destroy
  end

  private
  def dyna_form_params
    params.require(:dyna_form).permit(:title, :description)
  end

  def set_dyna_form
    @dyna_form = Current.user.dyna_forms.find(params[:id]) if Current.user
  end
end