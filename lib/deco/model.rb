# frozen_string_literal: true

require_relative 'attribute_creatable'
require_relative 'hash_loadable'
require_relative 'model_nameable'
require_relative 'optionable'

module Deco
  # This class defines the base class for classes that create
  # dynamic models that can be used as decorators.
  class Model
    include ActiveModel::Model
    include AttributeCreatable
    include AttributeRequireable
    include HashLoadable
    include ModelNameable

    validate :validate_required_attributes

    def initialize(object:, options: { attrs: Deco::AttributeOptionable::MERGE })
      @attribute_info = {}

      load object: object, options: options if object.present?
    end

    def load(object:, options:)
      if object.is_a?(Hash)
        load_hash(hash: object, options: options)
      else
        raise ArgumentError, "object (#{object.class}) was not handled"
      end
    end

    def attribute_names
      attribute_info.keys
    end

    # Validator for attribute names. This validator simply checks to make
    # sure that the attribute was created, which can only occur if:
    # A) The attribute was defined on the model explicitly (e.g. attr_accessor :attribute).
    # B) The attribute was created as a result of loading data dynamically.
    # :reek:ManualDispatch - methods added dynamically; this is the best way to check.
    def validate_required_attributes
      required_attributes.each do |attribute_name|
        next if respond_to? attribute_name

        errors.add(attribute_name, 'attribute is missing', type: :missing_required_attribute)
      end
    end
  end
end
