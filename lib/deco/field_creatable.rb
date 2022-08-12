# frozen_string_literal: true

require_relative 'field_conflictable'

module Deco
  # Takes an array of symbols and creates attr_accessors.
  module FieldCreatable
    include FieldConflictable

    def create_field_accessors(field_names:, options:)
      return if field_names.blank?

      field_names.each do |field_name|
        create_field_accessor(field_name: field_name, options: options)
      end
    end

    def create_field_accessor(field_name:, options:)
      validate_field_conflicts!(field_name: field_name, options: options)

      self.class.attr_accessor(field_name) if field_name.present?
    end
  end
end
