# frozen_string_literal: true

module Deco
  # Defines methods to retrieve model attribute values dynamically.
  module AttributeRetrievable

    # Returns the value of the attribute using fully quaified attribute names.
    def retrieve_attribute_value(hash:, attribute_info:)
      hash.dig(*[attribute_info[:in], attribute_info[:attribute_name]].flatten.compact)
    end
  end
end
