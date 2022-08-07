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
      @options&.dup || options_with_defaults(options: {})
    end

    def validate_options!
      self.class.validate_options! options: options
    end

    def field
      key = OPTION_FIELDS
      options[key] || OPTION_FIELDS_DEFAULT
    end

    def namespace
      key = OPTION_NAMESPACE
      options[key] || OPTION_NAMESPACE_DEFAULT
    end

    def merge?
      field == OPTION_FIELDS_MERGE
    end

    def strict?
      field == OPTION_FIELDS_STRICT
    end

    def namespace?
      key = OPTION_NAMESPACE
      options[key].present?
    end

    private

    def options=(value)
      self.class.validate_options! options: value

      @options = value.dup
    end

    def options_with_defaults(options:, defaults: DEFAULT_OPTIONS)
      options ||= {}
      defaults.merge(options)
    end
  end
end
