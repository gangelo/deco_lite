# frozen_string_literal: true

require_relative 'optionable'

module Deco
  # This class defines the base class for classes that create
  # dynamic models that can be used as decorators.
  class Model
    include ActiveModel::Model
    include AttrAccessorCreatable
    include HashLoadable

    class << self
      def model_name
        ActiveModel::Name.new(self, nil, to_s.gsub('::', ''))
      end

      # Returns the attribute names based on the validators we've set up.
      def attribute_names
        @attribute_names ||= validators.filter_map do |validator|
          validator.attributes.first
        end&.flatten&.uniq&.sort
      end
    end

    validate :validate_attribute_names

    attr_reader :attribute_info

    def initialize(object:, options: { attrs: Deco::AttributeOptionable::MERGE })
      @attribute_info = {}

      attr_accessor_create attribute_names: attribute_names

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
      (attribute_info.keys + [self.class.attribute_names.presence]).flatten.compact.uniq
    end

    private

    attr_writer :attribute_info

    # Validator for attribute names. All attributes (not the presence of data) are required.
    def validate_attribute_names
      self.class.attribute_names.each do |attribute_name|
        next if attribute_info.key? attribute_name

        errors.add(attribute_name, 'attribute is missing', type: missing_required_attribute)
      end
    end
  end
end
