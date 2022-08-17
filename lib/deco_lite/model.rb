# frozen_string_literal: true

require 'active_model'
require 'mad_flatter'
require_relative 'field_assignable'
require_relative 'field_creatable'
require_relative 'field_requireable'
require_relative 'hashable'
#require_relative 'hash_loadable'
require_relative 'model_nameable'
require_relative 'optionable'

module DecoLite
  # This class defines the base class for classes that create
  # dynamic models that can be used as decorators.
  class Model
    include ActiveModel::Model
    include FieldAssignable
    include FieldCreatable
    include FieldRequireable
    include Hashable
    #include HashLoadable
    include ModelNameable
    include Optionable

    validate :validate_required_fields

    def initialize(options: {})
      @field_info = {}
      @field_names = []
      # Accept whatever options are sent, but make sure
      # we have defaults set up. #options_with_defaults
      # will merge options into OptionsDefaultable::DEFAULT_OPTIONS
      # so we have defaults for any options not passed in through
      # options.
      self.options = Options.with_defaults options
    end

    def load(hash:, options: {})
      # Merge options into the default options passed through the
      # constructor; these will override any options passed in when
      # this object was created, allowing us to retain any defaut
      # options while loading, but also provide option customization
      # of options when needed.
      options = Options.with_defaults(options, defaults: self.options)
      #load_hash(hash: hash, options: options)

      mad_flatter = MadFlatter::Service.new
      mad_flatter_default_options = mad_flatter.options
      mad_flatter_options = mad_flatter_default_options.to_h.merge \
        options.to_h.slice(*MadFlatter::OptionsDefaultable::DEFAULT_OPTIONS.keys)
      new_hash = mad_flatter.execute(hash: hash, options: mad_flatter_options)
      new_hash.each_pair do |key, value|
        create_field_accessor field_name: key, options: options
        field_names << key
        set_field_value(field_name: key, value: value, options: options)
      end

      self
    end

    attr_reader :field_names

    private

    attr_writer :field_names
  end
end
