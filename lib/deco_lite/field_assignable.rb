# frozen_string_literal: true

require_relative 'field_creatable'
require_relative 'field_retrievable'

module DecoLite
  # Defines methods to assign model field values dynamically.
  module FieldAssignable
    include FieldCreatable
    include FieldRetrievable

    def set_field_values(hash:, field_info:, options:)
      field_info.each do |name, info|
        value = get_field_value(hash: hash, field_info: info)
        set_field_value(field_name: name, value: value, options: options)
      end
    end

    def set_field_value(field_name:, value:, options:)
      # Create our fields before we send.
      create_field_accessor field_name: field_name, options: options
      send("#{field_name}=", value)
    end
  end
end
