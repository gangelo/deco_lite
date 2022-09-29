# frozen_string_literal: true

require 'immutable_struct_ex'
require_relative 'options_defaultable'
require_relative 'options_validatable'

module DecoLite
  # Defines methods to create options.
  module Options
    extend DecoLite::OptionsDefaultable
    extend DecoLite::OptionsValidatable

    class << self
      def new(**options)
        immutable_struct_ex = ImmutableStructEx.new(**options) do
          def merge?
            fields == OPTION_FIELDS_MERGE
          end

          def strict?
            fields == OPTION_FIELDS_STRICT
          end

          def namespace?
            namespace.present? || false
          end
        end
        validate_options! options: immutable_struct_ex.to_h
        immutable_struct_ex
      end

      def with_defaults(options, defaults: DEFAULT_OPTIONS)
        new(**defaults.to_h.merge(options.to_h))
      end

      def default
        with_defaults({})
      end
    end
  end
end
