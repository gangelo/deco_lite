# frozen_string_literal: true

module DecoLite
  # Provides methods to convert the object to a Hash.
  module Hashable
    def to_h
      field_names.each_with_object({}) do |field_name, hash|
        field_value = public_send(field_name)

        field_name, field_value = yield [field_name, field_value] if block_given?

        hash[field_name] = field_value
      end
    end
  end
end
