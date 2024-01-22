# frozen_string_literal: true

require_relative 'field_conflictable'
require_relative 'field_validatable'

module DecoLite
  # Takes an array of symbols and creates attr_accessors.
  module FieldCreatable
    include FieldConflictable
    include FieldValidatable

    def create_field_accessors(field_names:, options:)
      return if field_names.blank?

      field_names.each do |field_name|
        create_field_accessor(field_name:, options:)
      end
    end

    def create_field_accessor(field_name:, options:)
      validate_field_name!(field_name:, options:)
      validate_field_conflicts!(field_name:, options:)

      # If we want to set a class-level attr_accessor
      # self.class.attr_accessor(field_name) if field_name.present?

      create_field_getter(field_name:, options:)
      create_field_setter field_name:, options:
    end

    private

    # rubocop:disable Lint/UnusedMethodArgument
    def create_field_getter(field_name:, options:)
      define_singleton_method(field_name) do
        instance_variable_get :"@#{field_name}"
      end
    end

    def create_field_setter(field_name:, options:)
      define_singleton_method(:"#{field_name}=") do |value|
        instance_variable_set :"@#{field_name}", value
      end
    end
    # rubocop:enable Lint/UnusedMethodArgument
  end
end
