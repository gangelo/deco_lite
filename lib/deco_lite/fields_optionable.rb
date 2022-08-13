# frozen_string_literal: true

module DecoLite
  # Defines the fields option hash key and acceptable hash key values.
  module FieldsOptionable
    # The option hash key for this option.
    OPTION_FIELDS = :fields
    # The valid option values for this option key.
    OPTION_FIELDS_MERGE = :merge
    OPTION_FIELDS_STRICT = :strict
    # The default value for this option.
    OPTION_FIELDS_DEFAULT = OPTION_FIELDS_MERGE
    # The valid option key values for this option.
    OPTION_FIELDS_VALUES = [OPTION_FIELDS_MERGE, OPTION_FIELDS_STRICT].freeze
  end
end
