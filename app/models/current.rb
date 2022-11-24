class Current < ActiveSupport::CurrentAttributes
  attribute :session, :user

  def ordered_input_types
    @ordered_input_types ||= InputType.all.order(:display_order)
  end
end
