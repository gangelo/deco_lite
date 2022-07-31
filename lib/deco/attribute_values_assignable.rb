# frozen_string_literal: true

module Deco
  # Defines methods to assign model attribute values dynamically.
  module AttributeValuesAssignable
    def assign_attribute_values(hash:, attribute_info:)
      attribute_info.each do |attribute_name, attr_info|
        value = hash.dig(*[attr_info[:in], attr_info[:attribute_name]].flatten.compact)
        assign_attribute_value(attribute_name: attribute_name, value: value)
      end
    end

    def assign_attribute_value(attribute_name:, value:)
      raise "Attribute '#{attribute_name}' is not defined. Have they been created?" unless respond_to? attribute_name

      public_send("#{attribute_name}=", value)
    end
  end
end
