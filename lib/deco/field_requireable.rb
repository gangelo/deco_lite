# frozen_string_literal: true

module Deco
  # Provides methods to manage fields that must be defined from
  # the dynamically loaded data.
  module FieldRequireable
    # Returns field names that will be used to validate the presence of
    # dynamically created fields from loaded objects.
    #
    # You must override this method if you want to return field names that
    # are required to be present. You may simply return a static array, but
    # if you want to dynamically manipulate this field, return a variable.
    def required_fields
      # @required_fields ||= []
      []
    end

    # Validator for field names. This validator simply checks to make
    # sure that the field was created, which can only occur if:
    # A) The field was defined on the model explicitly (e.g. attr_accessor :field).
    # B) The field was created as a result of loading data dynamically.
    def validate_required_fields
      required_fields.each do |field_name|
        next if required_field_exist? field_name: field_name

        errors.add(field_name, 'field is missing', type: :missing_required_field)
      end
    end

    # :reek:ManualDispatch - method added dynamically; this is the best way to check.
    def required_field_exist?(field_name:)
      respond_to?(field_name) && respond_to?("#{field_name}=".to_sym)
    end
  end
end
