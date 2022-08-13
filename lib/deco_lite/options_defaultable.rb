# frozen_string_literal: true

require_relative 'fields_optionable'
require_relative 'namespace_optionable'

module DecoLite
  # Defines default options and their optionn values.
  module OptionsDefaultable
    include DecoLite::FieldsOptionable
    include DecoLite::NamespaceOptionable

    DEFAULT_OPTIONS = {
      OPTION_FIELDS => OPTION_FIELDS_DEFAULT,
      OPTION_NAMESPACE => OPTION_NAMESPACE_DEFAULT
    }.freeze
  end
end
