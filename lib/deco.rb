# frozen_string_literal: true

require 'active_model'
# require 'active_support'
# require 'active_support/core_ext/object/blank'

Dir[File.join('.', 'lib/deco/**/*.rb')].each do |f|
  require f
end
