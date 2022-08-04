# frozen_string_literal: true

module Deco
  # Takes an array of symbols and creates attr_accessors.
  module FieldCreatable
    def create_field_accessors(field_names:)
      self.class.attr_accessor(*field_names) if field_names.present?
    end

    def create_field_accessor(field_name:)
      self.class.attr_accessor(field_name) if field_name.present?
    end
  end
end
