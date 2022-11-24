class SubmittedForm < ApplicationRecord
  belongs_to :dyna_form

  has_many :submitted_form_responses

  attr_accessor :all_responses_valid

  scope :are_completed, -> { where(completed: true) }

  #
  # Marks the submitted form as completed
  #
  # @return [void]
  #
  def complete
    return false unless @all_responses_valid

    update(completed: true, complete_date: Time.now) unless completed?
  end

  #
  # Validation check for the submitted form to be complete
  #
  # @return [Boolean]
  #
  def process_submissions(submitted_responses = submitted_form_responses, with_dyna_form_validation = true)
    @all_responses_valid = submitted_responses.reduce(true) do |acc, sfr|
      sfr.save(with_dyna_form_validation)
      acc && sfr.errors.empty?
    end
  end
end
