# frozen_string_literal: true

module Deco
  # Takes an array of symbols and creates attr_accessors.
  module AttributeCreatable
    def create_attribute_accessors(attribute_names:)
      self.class.attr_accessor(*attribute_names)
    end

    def create_attribute_accessor(attribute_name:)
      self.class.attr_accessor(attribute_name)
    end
  end
end
