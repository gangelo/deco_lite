# frozen_string_literal: true

require 'immutable_struct_ex'
require_relative 'options'
require_relative 'options_validatable'

module DecoLite
  # Defines methods and fields to manage options.
  module Optionable
    include OptionsValidatable

    def options
      @options || Options.default
    end

    private

    def options=(value)
      options_hash = value.to_h

      validate_options! options: options_hash

      @options = Options.new(**options_hash)
    end
  end
end
