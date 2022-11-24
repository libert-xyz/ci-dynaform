class FormInput < ApplicationRecord
  belongs_to :dyna_form
  belongs_to :input_type

  has_many :submitted_form_responses

  validates :label, presence: true
  validate :has_additional_attributes?
  validate :form_is_unlocked?

  before_create :set_display_order

  before_update :form_is_unlocked?

  after_create_commit do
    dyna_form.form_inputs.reload

    broadcast_append_to("dyna_form_#{dyna_form.id}_form_input_samples",
      target: "dyna_form_#{dyna_form.id}_form_input_samples",
      partial: 'form_inputs/sample',
      locals: {form_input: self, submitted_form_response: SubmittedFormResponse.new(form_input_id: id)}
    )

    broadcast_replace_to "user_#{Current.user.id}_dyna_forms",
      target: "dyna_form_#{dyna_form.id}",
      partial: 'dyna_forms/dyna_form',
      locals: {dyna_form: self.dyna_form} if Current.user
  end
  after_destroy_commit do
    dyna_form.form_inputs.reload

    broadcast_remove_to("dyna_form_#{dyna_form.id}_form_input_samples",
      target: "form_input_#{id}_sample"
    )

    broadcast_replace_to "user_#{Current.user.id}_dyna_forms",
      target: "dyna_form_#{dyna_form.id}",
      partial: 'dyna_forms/dyna_form',
      locals: {dyna_form: self.dyna_form} if Current.user
  end

  #
  # Helper method for parsing additional attributes into a json struct
  #
  # @return [Array]
  #
  def parsed_additional_attributes
    current_attrs = additional_attributes || ''
    JSON.parse(current_attrs) rescue current_attrs.split(',')
  end

  #
  # Override default additional_attributes= to convert comma-separated into a santized array
  #
  # @retiurn [void]
  #
  def additional_attributes=(val = '')
    super val.split(',').map {|v| v.strip }.join(',')
  end

  private

  def has_additional_attributes?
    return unless input_type.allows_additional_attributes?

    self.errors.add(:additional_attributes, "required for select option, checkbox, or radio select") unless additional_attributes.present?
  end

  def form_is_unlocked?
    self.errors.add("DynaForm", "is locked, further changes are not permitted") if self.dyna_form.locked
  end

  def set_display_order
    dyna_form.form_inputs.reload
    assign_attributes(display_order: dyna_form.form_inputs.length + 1)
  end
end
