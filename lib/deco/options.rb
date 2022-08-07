# frozen_string_literal: true

module Deco
  # Defines a class to encapsulate options.
  class Options
    include Optionable

    def initialize(options: nil)
      self.options = options_with_defaults options: options
    end
  end
end
