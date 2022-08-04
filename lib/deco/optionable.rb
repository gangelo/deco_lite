# frozen_string_literal: true

require_relative 'fields_optionable'
require_relative 'namespace_optionable'
require_relative 'options_defaultable'
require_relative 'options_validatable'

module Deco
  # Defines methods and fields to manage options.
  module Optionable
    include Deco::FieldsOptionable
    include Deco::NamespaceOptionable
    include Deco::OptionsDefaultable

    class << self
      def included(base)
        base.extend(Deco::OptionsValidatable)
      end
    end

    def options
      @options&.dup || OptionsDefaultable::DEFAULT_OPTIONS
    end

    def validate_options!
      self.class.validate_options! options: options
    end

    def field
      options[:fields] || FieldsOptionable::OPTION_FIELDS_DEFAULT
    end

    def namespace
      options[:namespace]
    end

    def merge?
      field == FieldsOptionable::OPTION_FIELDS_MERGE
    end

    def strict?
      field == FieldsOptionable::OPTION_FIELDS_STRICT
    end

    def namespace?
      options[:namespace].present?
    end

    private

    def options=(value)
      options = options_merge value
      self.class.validate_options! options: options

      @options = options
    end

    def options_merge(options)
      options ||= {}
      DEFAULT_OPTIONS.merge(options)
    end
  end
end
