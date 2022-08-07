# frozen_string_literal: true

require_relative 'field_assignable'
require_relative 'field_informable'

module Deco
  # Provides methods to load and return information about a given hash.
  module HashLoadable
    include FieldAssignable
    include FieldInformable

    private

    def load_hash(hash:, options: {})
      validate_arguments!(hash: hash, options: options)

      return if hash.blank?

      field_info = field_info_from(hash: hash, namespace: options[:namespace])
      assign_field_values(hash: hash, field_info: field_info)
      merge_field_info! field_info: field_info
    end

    def validate_arguments!(hash:, options:)
      raise ArgumentError, 'hash is not a Hash' unless hash.is_a? Hash
      raise ArgumentError, 'options is not a Hash' unless options.is_a? Hash
    end
  end
end
