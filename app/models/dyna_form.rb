class DynaForm < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validate :is_unlocked?

  belongs_to :creator,
    foreign_key: :user_id,
    class_name: "User"

  has_many :form_inputs

  has_many :submitted_forms

  has_many :submitted_form_reponses,
    through: :submitted_forms

  after_create_commit do
    broadcast_prepend_to "user_#{Current.user.id}_dyna_forms",
      target: "user_#{Current.user.id}_dyna_forms" if Current.user
  end

  after_update_commit do
    partial_path = locked? ? "preview" : "dyna_form_with_inputs"
    broadcast_replace_to "user_#{Current.user.id}_dyna_forms" if Current.user
    broadcast_replace_to "session_#{Current.session.id}",
        target: "user_dyna_form_window",
        partial: "dyna_forms/#{partial_path}",
        locals: {dyna_form: self}
  end

  after_destroy_commit do
    if Current.user
      broadcast_remove_to "user_#{Current.user.id}_dyna_forms"
      broadcast_remove_to "session_#{Current.session.id}"
    end
  end

  scope :published, -> {
    where(published: true)
  }

  #
  # Query for retrieving results of a form submissions
  #
  # @param id [uuid] the id of the form to retrieve submission data
  #
  # @return [ActiveRecord_Collection::DynaForm]
  #
  def self.submission_data(id, completed)
    DynaForm
      .select("submitted_forms.id, submitted_form_responses.value, form_inputs.label, submitted_forms.complete_date, submitted_form_responses.form_input_id as header_id")
      .joins(submitted_forms: [submitted_form_responses: :form_input])
      .where(dyna_forms: {id: id})
      .where(submitted_forms: {completed: completed})
      .order("submitted_forms.created_at desc, form_inputs.display_order")
  end

  #
  # Returns the pivoted data for completed form submissions
  #
  # @return [Array<Array, Array>]
  #
  def completed_pivot_table
    data = DynaForm.submission_data(id, true)
    headers = form_inputs.order(:display_order).pluck(:label, :id)
    [pivot_data(data), headers]
  end

  #
  # Returns the pivoted data for saved form submissions
  #
  # @return [Array<Array, Array>]
  #
  def pending_pivot_table
    data = DynaForm.submission_data(id, false)
    headers = form_inputs.order(:display_order).pluck(:label, :id)
    [pivot_data(data), headers]
  end

  #
  # Pivots the data for rendering in a results table
  #
  # @param data [Array]
  #
  # @return [Array]
  #
  def pivot_data(data)
    [].tap do |new_data|
      new_row = {}
      data.each do |row|
        if new_row.has_key?(row.header_id)
          new_data << new_row
          new_row = {}
        end
        new_row[row.header_id] = row.value
      end

      new_data << new_row
    end
  end

  def publish
    update!(published: true, locked: true)
  end

  def unpublish
    update!(published: false)
  end

  private
  def is_unlocked?
    changed_attrs = changed_attributes.except(:published, :locked)
    self.errors.add("DynaForm", "is locked, further changes are not permitted") if self.locked && changed_attrs.any?
  end
end
