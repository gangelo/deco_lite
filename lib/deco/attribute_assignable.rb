# frozen_string_literal: true

require_relative 'attribute_creatable'
require_relative 'attribute_retrievable'

module Deco
  # Defines methods to assign model attribute values dynamically.
  module AttributeAssignable
    include AttributeCreatable
    include AttributeRetrievable

    def assign_attribute_values(hash:, attribute_info:)
      attribute_info.each do |attribute_name, attr_info|
        value = retrieve_attribute_value(hash: hash, attribute_info: attr_info)
        assign_attribute_value(attribute_name: attribute_name, value: value)
      end
    end

    def assign_attribute_value(attribute_name:, value:)
      # Create our attributes before we send.
      create_attribute_accessor attribute_name: attribute_name
      send("#{attribute_name}=", value)
    end
  end
end
