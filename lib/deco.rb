# frozen_string_literal: true

Dir[File.join('.', 'lib/deco/**/*.rb')].each do |f|
  require f
end
