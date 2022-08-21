# frozen_string_literal: true

module DecoLite
  # Defines methods validate field (attribute) names.
  module FieldValidatable
    FIELD_NAME_REGEX = /\A(?:[a-z_]\w*[?!=]?|\[\]=?|<<|>>|\*\*|[!~+\*\/%&^|-]|[<>]=?|<=>|={2,3}|![=~]|=~)\z/i.freeze

    module_function

    def validate_field_name!(field_name:, options: nil)
      unless field_name =~ FIELD_NAME_REGEX
        raise "field_name '#{field_name}' is not a valid field name."
      end
    end
  end
end
