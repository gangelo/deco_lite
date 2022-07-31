# frozen_string_literal: true

module Deco
  # Defines methods and attributes to manage options.
  module Optionable
    OPTIONS = %i[attrs namespace].freeze
    OPTION_ATTRS_VALUES = [AttributeOptionable::MERGE, AttributeOptionable::STRICT].freeze

    class << self
      include Deco::AttributeOptionable
    end

    def validate_options!
      raise ArgumentError, 'options is not a Hash' unless options.is_a? Hash

      return true if options.empty?

      validate_option_keys!
      validate_option_attr!
      validate_option_namespace!
    end

    def attr
      options[:attrs] || AttributeOptionable::DEFAULT
    end

    def namespace
      options[:namespace]
    end

    def merge?
      attr == AttributeOptionable::MERGE
    end

    def strict?
      attr == AttributeOptionable::STRICT
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

    def validate_option_attr!
      option = attr
      return if OPTION_ATTRS_VALUES.include?(option)

      raise ArgumentError,
        "option :attrs value or type is invalid. #{OPTION_ATTRS_VALUES} (Symbol) " \
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
