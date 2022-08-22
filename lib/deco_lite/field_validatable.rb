# frozen_string_literal: true

module DecoLite
  # Defines methods validate field (attribute) names.
  module FieldValidatable
    FIELD_NAME_REGEX = %r{\A(?:[a-z_]\w*[?!=]?|\[\]=?|<<|>>|\*\*|[!~+*/%&^|-]|[<>]=?|<=>|={2,3}|![=~]|=~)\z}i

    module_function

    # rubocop:disable Lint/UnusedMethodArgument
    def validate_field_name!(field_name:, options: nil)
      raise "field_name '#{field_name}' is not a valid field name." unless FIELD_NAME_REGEX.match?(field_name)
    end
    # rubocop:enable Lint/UnusedMethodArgument
  end
end
