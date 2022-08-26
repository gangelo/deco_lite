# frozen_string_literal: true

require_relative 'fields_optionable'
require_relative 'namespace_optionable'
require_relative 'required_fields_optionable'

module DecoLite
  # Defines default options and their optionn values.
  module OptionsDefaultable
    include DecoLite::FieldsOptionable
    include DecoLite::NamespaceOptionable
    include DecoLite::RequiredFieldsOptionable

    DEFAULT_OPTIONS = {
      OPTION_FIELDS => OPTION_FIELDS_DEFAULT,
      OPTION_NAMESPACE => OPTION_NAMESPACE_DEFAULT,
      OPTION_REQUIRED_FIELDS => OPTION_REQUIRED_FIELDS_DEFAULT
    }.freeze
  end
end
