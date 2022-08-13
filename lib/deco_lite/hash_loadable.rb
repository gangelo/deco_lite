# frozen_string_literal: true

require_relative 'field_assignable'
require_relative 'field_informable'

module DecoLite
  # Provides methods to load and return information about a given hash.
  module HashLoadable
    include FieldAssignable
    include FieldInformable

    private

    def load_hash(hash:, options:)
      raise ArgumentError, "Argument hash is not a Hash (#{hash.class})" unless hash.is_a? Hash

      return if hash.blank?

      field_info = get_field_info(hash: hash, namespace: options.namespace)
      set_field_values(hash: hash, field_info: field_info, options: options)
      merge_field_info! field_info: field_info
    end
  end
end
