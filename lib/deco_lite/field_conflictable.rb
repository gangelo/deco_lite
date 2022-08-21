# frozen_string_literal: true

require_relative 'fields_optionable'

module DecoLite
  # Defines methods to to manage fields that conflict with
  # existing model attributes.
  module FieldConflictable
    include FieldsOptionable

    def validate_field_conflicts!(field_name:, options:)
      return unless field_conflict?(field_name: field_name, options: options)

      raise "Field :#{field_name} conflicts with existing method(s) " \
        ":#{field_name} and/or :#{field_name}=; " \
        'this will raise an error when loading using strict mode ' \
        "(i.e. options: { #{OPTION_FIELDS}: :#{OPTION_FIELDS_STRICT} }) " \
        'or if the method(s) are native to the object (e.g :to_s, :==, etc.).'
    end

    # This method returns true
    def field_conflict?(field_name:, options:)
      # If field_name was already added using Model#load, there is only a
      # conflict if options.strict? is true.
      if field_names_include?(field_name: field_name)
        return options.strict?
      end

      # If we get here, we know that :field_name does not exist as an
      # attribute on the model. If the attribute already exists on the
      # model, this is a conflict because we cannot override an attribute
      # that already exists on the model
      attr_accessor_exist?(field_name: field_name)
    end

    def field_names_include?(field_name:)
      field_names.include? field_name
    end

    def attr_accessor_exist?(field_name:)
      respond_to?(field_name) || respond_to?(:"#{field_name}=")
    end
  end
end
