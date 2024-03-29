# frozen_string_literal: true

require 'mad_flatter'
require_relative 'field_assignable'
require_relative 'field_creatable'

module DecoLite
  # Provides methods to load and return information about a given hash.
  module HashLoadable
    include FieldAssignable
    include FieldCreatable

    private

    def load_hash(hash:, deco_lite_options:)
      raise ArgumentError, "Argument hash is not a Hash (#{hash.class})" unless hash.is_a? Hash

      return {} if hash.blank?

      load_service_options = merge_with_load_service_options(deco_lite_options:)
      load_service.execute(hash:, options: load_service_options).tap do |service_hash|
        service_hash.each_pair do |field_name, value|
          create_field_accessor field_name:, options: deco_lite_options
          yield field_name if block_given?
          field_names << field_name unless field_names.include? field_name
          set_field_value(field_name:, value:, options: deco_lite_options)
        end
      end
    end

    def load_service
      @load_service ||= MadFlatter::Service.new
    end

    def merge_with_load_service_options(deco_lite_options:)
      load_service.options.to_h.merge \
        deco_lite_options.to_h.slice(*MadFlatter::OptionsDefaultable::DEFAULT_OPTIONS.keys)
    end
  end
end
