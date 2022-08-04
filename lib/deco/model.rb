# frozen_string_literal: true

require_relative 'field_creatable'
require_relative 'field_requireable'
require_relative 'hash_loadable'
require_relative 'model_nameable'
require_relative 'optionable'

module Deco
  # This class defines the base class for classes that create
  # dynamic models that can be used as decorators.
  class Model
    include ActiveModel::Model
    include FieldCreatable
    include FieldRequireable
    include HashLoadable
    include ModelNameable

    validate :validate_required_fields

    def initialize(object:, options: { fields: Deco::FieldOptionable::MERGE })
      @field_info = {}

      load object: object, options: options if object.present?
    end

    def load(object:, options:)
      if object.is_a?(Hash)
        load_hash(hash: object, options: options)
      else
        raise ArgumentError, "object (#{object.class}) was not handled"
      end
    end

    def field_names
      field_info.keys
    end
  end
end
