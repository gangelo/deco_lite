# frozen_string_literal: true

module DecoLite
  # Provides methods to convert the object to a Hash.
  module Hashable
    def to_h
      field_names.each.each_with_object({}) do |field_name, hash|
        hash[field_name] = public_send field_name
      end
    end
  end
end
