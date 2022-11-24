class InputType < ApplicationRecord

  #
  # Determines if the input type allows additional attributes
  #
  # @return [Boolean]
  #
  def allows_additional_attributes?
    ruby_klass == "SelectOption" || ruby_klass == "Checkbox"
  end

  #
  # Method for converting the additional_attributes based on the input type
  #
  # @param val [String] the raw additional_attributes
  #
  # @return [String]
  #
  def process_additional_attributes(val)
    case ruby_klass
    when "SelectOption" then comma_separated_to_json_string(val)
    when "Checkbox" then comma_separated_to_json_string(val)
    else val
    end
  end

  #
  # Maps a comma-separated string into a json array string
  #
  # @param val [String] the value to be turned into a json string
  #
  # @return [String]
  #
  def comma_separated_to_json_string(val)
    JSON.pretty_generate(
      val.split(',').map { |v| v.strip }
    )
  end

  #
  # Returns the class associated with the input type
  #
  # @return [Symbol]
  #
  def klass
    "InputType::#{ruby_klass}".constantize
  end

  #
  # Method for parsing the additional attributes based on the selected type
  #
  # @param val [String] the additional_attributes column
  #
  # @return [String | Array<String>]
  #
  def parsed_additional_attributes(val)
    case ruby_klass
    when "SelectOption" then JSON.parse(val)
    when "Checkbox" then JSON.parse(val)
    else val
    end
  end

  #
  # Returns the parsed validations hash
  #
  # @return [Hash]
  #
  def parsed_validations
    @parsed_validations ||= validates.present? ? JSON.parse(validates) : {}
  end

  class BaseInputType
    attr_accessor :input_type, :submitted_form_response
    def initialize(submitted_form_response)
      @submitted_form_response = submitted_form_response
      @input_type = submitted_form_response.input_type
      validate!
    end

    #
    # Calls valiation methods against the submitted response
    #
    # @return [void]
    #
    def validate!
      validate_required if submitted_form_response.required?
      validation_method = input_type.parsed_validations["method"]
      return unless validation_method

      validation_params = input_type.parsed_validations["params"] || {}
      self.send("validate_#{validation_method}", validation_params)
    end

    #
    # Validation method used for required inputs
    #
    # @return [void]
    #
    def validate_required(**params)
      submitted_form_response.errors.add("Input", "is required") unless submitted_form_response.value.present?
    end
  end

  class OptionSelect < BaseInputType;  end;

  class TextArea < BaseInputType;  end;

  class Checkbox < BaseInputType;  end;

  class Text < BaseInputType

    #
    # Validation method used for phone number inputs
    #
    # @return [void]
    #
    def validate_phone_number(**params)
      return unless submitted_form_response.value.present?

      submitted_form_response.errors.add("Phone number", "must contain only number") if submitted_form_response.value.match?(/[^0-9]/)
      submitted_form_response.errors.add("Phone number", "is not correct length") unless submitted_form_response.value.length == 10
    end

    #
    # Validation method used for email inputs
    #
    # @return [void]
    #
    def validate_email(**params)
      return unless submitted_form_response.value.present?

      submitted_form_response.errors.add("Email", "is not a valid format") unless submitted_form_response.value.match?(URI::MailTo::EMAIL_REGEXP)
    end
  end
end
