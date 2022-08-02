# frozen_string_literal: true

module Deco
  # Takes an array of symbols and creates attr_accessors.
  module AttributeCreatable
    def create_attribute_accessors(attribute_names:)
      self.class.attr_accessor(*attribute_names) if attribute_names.present?
    end

    def create_attribute_accessor(attribute_name:)
      self.class.attr_accessor(attribute_name) if attribute_name.present?
    end
  end
end
