# frozen_string_literal: true

module Deco
  # Provides methods to load and return information about a given hash.
  module HashLoadable
    include AttributeInformable
    include AttributeAssignable

    def load_hash(hash:, options: {})
      Validators.validate!(hash: hash, options: options)

      attribute_info = attribute_info_from(hash: hash, field_namespace: options[:namespace])
      @attribute_info.merge!(attribute_info)
      apply_attribute_values_from_hash(hash: hash, attribute_info: attribute_info)
    end

    def apply_attribute_values_from_hash(hash:, attribute_info:)
      assign_attribute_values hash: hash, attribute_info: attribute_info
    end

    # Module that defines validators for the parent module.
    module Validators
      class << self
        def validate!(hash:, options:)
          raise ArgumentError, 'hash is blank?' if hash.blank?
          raise ArgumentError, 'hash is not a Hash' unless hash.is_a? Hash
          raise ArgumentError, 'options is not a Hash' unless options.is_a? Hash
        end
      end
    end
  end
end
