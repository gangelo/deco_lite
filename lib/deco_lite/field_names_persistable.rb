# frozen_string_literal: true

module DecoLite
  # Takes an array of symbols and creates attr_accessors.
  module FieldNamesPersistable
    def field_names
      @field_names ||= instance_variable_get(:@field_names) || []
    end

    private

    attr_writer :field_names
  end
end
