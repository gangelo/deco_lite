# frozen_string_literal: true

#require_relative 'attribute_optionable'

module Deco
  # Defines methods and attributes to manage options.
  module Optionable
    OPTIONS = %i(attrs namespace)

    class << self
      include Deco::AttributeOptionable
    end

    attr_reader :options

    def validate_options!
      raise ArgumentError, 'options is not a Hash' unless options.is_a? Hash

      return true if options.empty?

      invalid_options = options.except(*OPTIONS)&.keys
      if invalid_options
        raise ArgumentError, "One or more options were unrecognized: #{invalid_options}"
      end
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
  end
end
