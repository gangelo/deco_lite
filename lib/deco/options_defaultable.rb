# frozen_string_literal: true

require_relative 'fields_optionable'
require_relative 'namespace_optionable'

module Deco
  # Defines default options and their optionn values.
  module OptionsDefaultable
    include Deco::FieldsOptionable
    include Deco::NamespaceOptionable

    DEFAULT_OPTIONS = {
      OPTION_FIELDS => OPTION_FIELDS_DEFAULT,
      OPTION_NAMESPACE => OPTION_NAMESPACE_DEFAULT
    }.freeze
  end
end
