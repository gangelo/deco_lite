# frozen_string_literal: true

module Deco
  # Defines a class to encapsulate options.
  class Options
    include Optionable

    def initialize(options_hash: nil)
      self.options = options_hash if options_hash.present?
    end
  end
end
