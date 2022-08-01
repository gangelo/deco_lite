# frozen_string_literal: true

module Deco
  # Provides methods to load and return information about a given hash.
  module HashLoadable
    include AttributeInformable
    include AttrAccessorCreatable
    include AttributeValuesAssignable

    def load_hash(hash:, options: {})
      raise ArgumentError, 'hash is blank?' if hash.blank?
      raise ArgumentError, 'hash is not a Hash' unless hash.is_a? Hash
      raise ArgumentError, 'options is not a Hash' unless options.is_a? Hash

      namespace = [options[:namespace]].compact
      attribute_info = attribute_info_from(hash: hash, namespace: namespace)
      @attribute_info.merge!(attribute_info)
      attr_accessor_create attribute_names: attribute_info&.keys
      apply_attribute_values_from_hash(hash: hash, attribute_info: attribute_info)
    end

    def apply_attribute_values_from_hash(hash:, attribute_info:)
      assign_attribute_values hash: hash, attribute_info: attribute_info
    end
  end
end
