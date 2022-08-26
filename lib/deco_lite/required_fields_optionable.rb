# frozen_string_literal: true

module DecoLite
  # Defines the fields option hash key and acceptable hash key values.
  module RequiredFieldsOptionable
    # The option hash key for this option.
    OPTION_REQUIRED_FIELDS = :required_fields
    # The valid option values for this option key.
    OPTION_REQUIRED_FIELDS_AUTO = :auto
    # The default value for this option.
    OPTION_REQUIRED_FIELDS_DEFAULT = OPTION_REQUIRED_FIELDS_AUTO
    # The valid option key values for this option.
    OPTION_REQUIRED_FIELDS_VALUES = [OPTION_REQUIRED_FIELDS_AUTO].freeze
  end
end
