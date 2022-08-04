# frozen_string_literal: true

require_relative 'field_creatable'
require_relative 'field_retrievable'

module Deco
  # Defines methods to assign model field values dynamically.
  module FieldAssignable
    include FieldCreatable
    include FieldRetrievable

    def assign_field_values(hash:, field_info:)
      field_info.each do |name, info|
        value = retrieve_field_value(hash: hash, field_info: info)
        assign_field_value(field_name: name, value: value)
      end
    end

    def assign_field_value(field_name:, value:)
      # Create our fields before we send.
      create_field_accessor field_name: field_name
      send("#{field_name}=", value)
    end
  end
end
