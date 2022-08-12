# frozen_string_literal: true

require_relative 'fields_optionable'

module Deco
  # Defines methods to to manage fields that conflict with
  # existing model attributes.
  module FieldConflictable
    include FieldsOptionable

    def validate_field_conflicts!(field_name:, options:)
      return unless options.strict? && field_conflicts?(field_name: field_name)

      raise "Field '#{field_name}' conflicts with existing attribute; " \
        'this will raise an error when running in strict mode: ' \
        "options: { #{OPTION_FIELDS}: :#{OPTION_FIELDS_STRICT} }."
    end

    def field_conflicts?(field_name:)
      respond_to? field_name
    end
  end
end
