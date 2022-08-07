# frozen_string_literal: true

module Deco
  # Defines methods to retrieve model field values dynamically.
  module FieldRetrievable
    module_function

    # Returns the value of the field using fully quaified field names.
    def get_field_value(hash:, field_info:)
      hash.dig(*[field_info[:dig], field_info[:field_name]].flatten.compact)
    end
  end
end
