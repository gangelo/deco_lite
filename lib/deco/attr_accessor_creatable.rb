# frozen_string_literal: true

module Deco
  # Takes an array of symbols and creates attr_accessors.
  module AttrAccessorCreatable
    def attr_accessor_create(attribute_names:)
      self.class.attr_accessor(*attribute_names)
    end
  end
end
