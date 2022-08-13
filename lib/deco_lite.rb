# frozen_string_literal: true

Dir[File.join('.', 'lib/deco_lite/**/*.rb')].each do |f|
  require f
end
