# frozen_string_literal: true

require 'active_model'

Dir[File.join('.', 'lib/deco/**/*.rb')].each do |f|
  require f
end
