# frozen_string_literal: true

require 'i18n'

# This is the configuration for DecoLite.
module DecoLite
  class << self
    attr_reader :configuration

    # Returns the application configuration object.
    #
    # @return [Configuration] the application Configuration object.
    def configure
      self.configuration ||= Configuration.new

      yield(configuration)

      # If a different load path is being used, remove our default load path.
      i18n_load_path = configuration.i18n_load_path
      default_i18n_load_path = configuration.default_i18n_load_path
      if !configuration.default_i18n_load_path?(i18n_load_path) &&
        I18n.load_path.include?(default_i18n_load_path)
        I18n.load_path.delete(default_i18n_load_path)
      end

      I18n.load_path = I18n.load_path.unshift(i18n_load_path)
      I18n.default_locale = configuration.i18n_default_locale
    end

    private

    attr_writer :configuration
  end

  # This class encapsulates the configuration properties for this gem and
  # provides methods and attributes that allow for management of the same.
  class Configuration
    # Gets/sets whether or not i18n is used by this gem.
    #
    # The default is false.
    attr_accessor :i18n_on

    # Gets/sets the load paths for locale .yml files used by the i18n gem.
    #
    # By default, the i18n locale files used by this gem and supporting gems are used.
    #
    # @return [Array] the load paths for locale .yml files used by the i18n gem.
    attr_accessor :i18n_load_path

    # Gets/sets the default locale to be used by the i18n gem.
    #
    # The default is 5 megabytes.
    #
    # @return [Symbol] the default locale to be used by the i18n gem.
    attr_accessor :i18n_default_locale

    # The constructor; calls {#reset}.
    def initialize
      reset
    end

    def i18n_on?
      @i18n_on
    end

    # Resets the configuration settings to their default values.
    #
    # @return [void]
    def reset
      @i18n_on = false
      @i18n_load_path = default_i18n_load_path
      @i18n_default_locale = :en
    end

    def default_i18n_load_path?(load_path)
      load_path == default_i18n_load_path
    end

    def default_i18n_load_path
      @default_i18n_load_path ||= Dir["#{File.expand_path('lib/deco_lite/config/locales')}/*.yml"]
    end
  end
end
