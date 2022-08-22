# frozen_string_literal: true

require 'active_model'
require_relative 'field_creatable'
require_relative 'field_requireable'
require_relative 'field_names_persistable'
require_relative 'hash_loadable'
require_relative 'hashable'
require_relative 'model_nameable'
require_relative 'optionable'

module DecoLite
  # This class defines the base class for classes that create
  # dynamic models that can be used as decorators.
  class Model
    include ActiveModel::Model
    include FieldCreatable
    include FieldNamesPersistable
    include FieldRequireable
    include HashLoadable
    include Hashable
    include ModelNameable
    include Optionable

    validate :validate_required_fields

    def initialize(options: {})
      # Accept whatever options are sent, but make sure
      # we have defaults set up. #options_with_defaults
      # will merge options into OptionsDefaultable::DEFAULT_OPTIONS
      # so we have defaults for any options not passed in through
      # options.
      self.options = Options.with_defaults options
    end

    def load!(hash:, options: {})
      # Merge options into the default options passed through the
      # constructor; these will override any options passed in when
      # this object was created, allowing us to retain any defaut
      # options while loading, but also provide option customization
      # of options when needed.
      options = Options.with_defaults(options, defaults: self.options)

      load_hash(hash: hash, deco_lite_options: options)

      self
    end

    def load(hash:, options: {})
      puts 'WARNING: DecoLite::Model#load will be deprecated in a future release;' \
        ' use DecoLite::Model#load! instead!'

        load!(hash: hash, options: options)
    end
  end
end
