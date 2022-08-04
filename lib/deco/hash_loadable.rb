# frozen_string_literal: true

require_relative 'field_assignable'
require_relative 'field_informable'

module Deco
  # Provides methods to load and return information about a given hash.
  module HashLoadable
    include FieldAssignable
    include FieldInformable

    def load_hash(hash:, options: {})
      Validators.validate!(hash: hash, options: options)

      namespace = [options[:namespace]].compact
      field_info = field_info_from(hash: hash, namespace: namespace)
      @field_info.merge!(field_info)
      assign_field_values(hash: hash, field_info: field_info)
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
