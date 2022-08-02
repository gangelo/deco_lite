# frozen_string_literal: true

require_relative 'attribute_assignable'
require_relative 'attribute_informable'

module Deco
  # Provides methods to load and return information about a given hash.
  module HashLoadable
    include AttributeAssignable
    include AttributeInformable

    def load_hash(hash:, options: {})
      Validators.validate!(hash: hash, options: options)

      attribute_info = attribute_info_from(hash: hash, namespace: [options[:namespace]])
      @attribute_info.merge!(attribute_info)
      assign_attribute_values(hash: hash, attribute_info: attribute_info)
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
