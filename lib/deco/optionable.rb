# frozen_string_literal: true

require_relative 'field_optionable'

module Deco
  # Defines methods and fields to manage options.
  module Optionable
    OPTIONS = %i[fields namespace].freeze
    OPTION_ATTRS_VALUES = [FieldOptionable::MERGE, FieldOptionable::STRICT].freeze

    class << self
      include Deco::FieldOptionable
    end

    def validate_options!
      raise ArgumentError, 'options is not a Hash' unless options.is_a? Hash

      return true if options.empty?

      validate_option_keys!
      validate_option_field!
      validate_option_namespace!
    end

    def field
      options[:fields] || FieldOptionable::DEFAULT
    end

    def namespace
      options[:namespace]
    end

    def merge?
      field == FieldOptionable::MERGE
    end

    def strict?
      field == FieldOptionable::STRICT
    end

    def namespace?
      options[:namespace].present?
    end

    private

    attr_accessor :options

    def validate_option_keys!
      invalid_options = options.except(*OPTIONS)&.keys
      raise ArgumentError, "One or more options were unrecognized: #{invalid_options}" unless invalid_options.blank?
    end

    def validate_option_field!
      option = field
      return if OPTION_ATTRS_VALUES.include?(option)

      raise ArgumentError,
        "option :fields value or type is invalid. #{OPTION_ATTRS_VALUES} (Symbol) " \
          "was expected, but '#{option}' (#{option.class}) was received."
    end

    def validate_option_namespace!
      option = options[:namespace]
      return if option.is_a?(Symbol)

      raise ArgumentError, 'option :namespace value or type is invalid. A Symbol was expected, ' \
        "but '#{option}' (#{option.class}) was received."
    end
  end
end
