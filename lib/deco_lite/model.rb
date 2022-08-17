# frozen_string_literal: true

require 'active_model'
require 'mad_flatter'
require_relative 'field_assignable'
require_relative 'field_creatable'
require_relative 'field_requireable'
require_relative 'hashable'
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
    include ModelNameable
    include Optionable

    validate :validate_required_fields

    def initialize(options: {})
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

      load_hash(hash: hash, deco_lite_options: options)

      self
    end

    attr_reader :field_names

    private

    attr_writer :field_names

    def load_hash(hash:, deco_lite_options:)
      load_service_options = merge_with_load_service_options deco_lite_options: deco_lite_options
      load_service.execute(hash: hash, options: load_service_options).tap do |h|
        h.each_pair do |field_name, value|
          create_field_accessor field_name: field_name, options: deco_lite_options
          field_names << field_name
          set_field_value(field_name: field_name, value: value, options: deco_lite_options)
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
