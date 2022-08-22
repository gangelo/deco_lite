# frozen_string_literal: true

require_relative 'fields_optionable'
require_relative 'namespace_optionable'

module DecoLite
  # Methods to validate options.
  module OptionsValidatable
    include DecoLite::FieldsOptionable
    include DecoLite::NamespaceOptionable

    OPTIONS = [OPTION_FIELDS, OPTION_NAMESPACE].freeze

    def validate_options!(options:)
      raise ArgumentError, 'options is not a Hash' unless options.is_a? Hash

      validate_options_present! options: options

      validate_option_keys! options: options
      validate_option_fields! fields: options[:fields]
      validate_option_namespace! namespace: options[:namespace]
    end

    def validate_options_present!(options:)
      raise ArgumentError, 'options is blank?' if options.blank?
    end

    def validate_option_keys!(options:)
      invalid_options = options.except(*OPTIONS)&.keys
      raise ArgumentError, "One or more option keys were unrecognized: #{invalid_options}" unless invalid_options.blank?
    end

    def validate_option_fields!(fields:)
      return if OPTION_FIELDS_VALUES.include?(fields)

      raise ArgumentError,
        "option :fields value or type is invalid. #{OPTION_FIELDS_VALUES} (Symbol) " \
        "was expected, but '#{fields}' (#{fields.class}) was received."
    end

    def validate_option_namespace!(namespace:)
      # :namespace is optional.
      return if namespace.blank? || namespace.is_a?(Symbol)

      raise ArgumentError, 'option :namespace value or type is invalid. A Symbol was expected, ' \
                           "but '#{namespace}' (#{namespace.class}) was received."
    end
  end
end
