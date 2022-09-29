# frozen_string_literal: true

require 'active_model'
require_relative 'field_assignable'
require_relative 'field_names_persistable'
require_relative 'fields_auto_attr_accessable'
require_relative 'hash_loadable'
require_relative 'hashable'
require_relative 'model_nameable'
require_relative 'optionable'

module DecoLite
  # This class defines the base class for classes that create
  # dynamic models that can be used as decorators.
  class Model
    include ActiveModel::Model
    include FieldAssignable
    include FieldNamesPersistable
    include FieldsAutoloadable
    include HashLoadable
    include Hashable
    include ModelNameable
    include Optionable

    MISSING_REQUIRED_FIELD_ERROR_TYPE = :missing_required_field

    def initialize(hash: {}, options: {})
      # Accept whatever options are sent, but make sure
      # we have defaults set up. #options_with_defaults
      # will merge options into OptionsDefaultable::DEFAULT_OPTIONS
      # so we have defaults for any options not passed in through
      # options.
      self.options = Options.with_defaults options

      hash ||= {}

      load_hash!(hash: hash, options: options) if hash.present?

      load_hash!(hash: auto_attr_accessors, options: options, add_loaded_fields: false) if auto_attr_accessors?
    end

    validate :validate_required_fields

    # Returns field names that will be used to validate whether or not
    # these fields were loaded from hashes upon construction (#new) or
    # via #load!.
    #
    # You must override this method if you want to return field names that
    # are required to be present.
    def required_fields
      @required_fields ||= %i[]
    end

    def load!(hash:, options: {})
      load_hash! hash: hash, options: options
    end

    private

    attr_writer :required_fields

    def loaded_fields
      @loaded_fields ||= []
    end

    def load_hash!(hash:, options: {}, add_loaded_fields: true)
      # Merge options into the default options passed through the
      # constructor; these will override any options passed in when
      # this object was created, allowing us to retain any defaut
      # options while loading, but also provide option customization
      # of options when needed.
      options = Options.with_defaults(options, defaults: self.options)
      load_hash(hash: hash, deco_lite_options: options) do |loaded_field|
        loaded_fields << loaded_field if add_loaded_fields
      end

      self
    end

    # Validator for field names. This validator simply checks to make
    # sure that the field was created, which can only occur if:
    # A) The field was defined on the model explicitly (e.g. attr_accessor :field).
    # B) The field was created as a result of loading data dynamically.
    def validate_required_fields
      required_fields.each do |field_name|
        next if loaded_fields.include? field_name

        errors.add(field_name, field_missing_error,
          type: self.class::MISSING_REQUIRED_FIELD_ERROR_TYPE)
      end
    end

    def field_missing_error
      return 'field is missing' unless DecoLite.configuration.i18n_on?

      puts 'WARNING: The i18n feature is still in testing!'
      return I18n.t('deco_lite.errors.field_missing')
    end
  end
end
