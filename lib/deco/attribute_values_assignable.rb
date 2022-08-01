# frozen_string_literal: true

module Deco
  # Defines methods to assign model attribute values dynamically.
  module AttributeValuesAssignable
    include AttrAccessorCreatable

    def assign_attribute_values(hash:, attribute_info:)
      attribute_info.each do |attribute_name, attr_info|
        value = get_attribute_value(hash: hash, attribute_info: attr_info)
        assign_attribute_value(attribute_name: attribute_name, value: value)
      end
    end

    def assign_attribute_value(attribute_name:, value:)
      # Create our attributes before we send.
      attr_accessor_create attribute_names: [attribute_name]
      public_send("#{attribute_name}=", value)
    end

    def get_attribute_value(hash:, attribute_info:)
      hash.dig(*[attribute_info[:in], attribute_info[:attribute_name]].flatten.compact)
    end
  end
end
