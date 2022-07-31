# frozen_string_literal: true

#require_relative 'attribute_optionable'

module Deco
  # Defines methods and attributes to manage options.
  module Optionable
    OPTIONS = %i(attrs namespace).freeze
    OPTION_ATTRS_VALUES = [AttributeOptionable::MERGE, AttributeOptionable::STRICT]

    class << self
      include Deco::AttributeOptionable
    end

    attr_reader :options

    def validate_options!
      raise ArgumentError, 'options is not a Hash' unless options.is_a? Hash

      return true if options.empty?

      invalid_options = options.except(*OPTIONS)&.keys
      unless invalid_options.blank?
        raise ArgumentError, "One or more options were unrecognized: #{invalid_options}"
      end

      validate_option_attr!
      validate_option_namespace!
    end

    def merge?
      options[:attrs] == AttributeOptionable::MERGE
    end

    def strict?
      options[:attrs] == AttributeOptionable::STRICT
    end

    def namespace?
      options[:namespace].present?
    end

    private

    attr_writer :options

    def validate_option_attr!
      option = options[:attrs]
      return if option.nil? || OPTION_ATTRS_VALUES.include?(option)

      raise ArgumentError,
        "option :attrs value is invalid. #{OPTION_ATTRS_VALUES} (Symbol) " \
          "was expected, but '#{option}' (#{option.class}) was received."
    end

    def validate_option_namespace!
      option = options[:namespace]
      return if option.nil? || option.is_a?(Symbol)

      raise ArgumentError, "option :namespace value is invalid. A Symbol was expected, " \
        "but '#{option}' (#{option.class}) was received."
    end
  end
end
