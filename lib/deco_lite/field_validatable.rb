# frozen_string_literal: true

require 'i18n'

module DecoLite
  # Defines methods validate field (attribute) names.
  module FieldValidatable
    FIELD_NAME_REGEX = %r{\A(?:[a-z_]\w*[?!=]?|\[\]=?|<<|>>|\*\*|[!~+*/%&^|-]|[<>]=?|<=>|={2,3}|![=~]|=~)\z}i

    module_function

    # rubocop:disable Lint/UnusedMethodArgument
    def validate_field_name!(field_name:, options: nil)
      if DecoLite.configuration.i18n_on?
        puts 'WARNING: The i18n feature is still in testing!'
        raise I18n.t('deco_lite.errors.field_name_invalid', field_name: field_name) unless FIELD_NAME_REGEX.match?(field_name)
      else
        raise "field_name '#{field_name}' is not a valid field name" unless FIELD_NAME_REGEX.match?(field_name)
      end
    end
    # rubocop:enable Lint/UnusedMethodArgument
  end
end
