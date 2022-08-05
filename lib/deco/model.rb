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
    include Optionable

    validate :validate_required_fields

    def initialize(options: {})
      @field_info = {}
      # Accept whatever options are sent, but make sure
      # we have defaults set up. #options_with_defaults
      # will merge options into OptionsDefaultable::DEFAULT_OPTIONS
      # so we have defaults for any options not passed in through
      # options.
      self.options = options_with_defaults options: options
    end

    def load(object:, options: {})
      # Merge options into the default options passed through the
      # constructor; these will override any options passed in when
      # this object was created, allowing us to retain any defaut
      # options while loading, but also provide option customization
      # of options when needed.
      options = options_with_defaults options: options, defaults: self.options
      self.class.validate_options! options: options

      if object.is_a?(Hash)
        load_hash(hash: object, options: options)
      else
        raise ArgumentError, "object (#{object.class}) was not handled"
      end

      self
    end

    def field_names
      field_info.keys
    end
  end
end
