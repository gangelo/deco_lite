# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deco/version'

Gem::Specification.new do |spec|
  spec.name          = 'deco'
  spec.version       = Deco::VERSION
  spec.authors       = ['Gene M. Angelo, Jr.']
  spec.email         = ['public.gma@gmail.com']

  spec.summary       = 'Dynamically creates an active model from a Hash.'
  spec.description   = 'Dynamically creates an active model from a Hash.'
  spec.homepage      = 'https://github.com/gangelo/deco'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 3.0.1'

  spec.add_runtime_dependency 'activemodel', '~> 7.0', '>= 7.0.3.1'
  spec.add_runtime_dependency 'activesupport', '~> 7.0', '>= 7.0.3.1'
  spec.add_runtime_dependency 'immutable_struct_ex', '~> 0.2.0'
  # spec.add_development_dependency 'benchmark-ips', '~> 2.3'
  spec.add_development_dependency 'bundler', '~> 2.2', '>= 2.2.17'
  # spec.add_development_dependency 'factory_bot', '~> 6.2'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  # #spec.add_development_dependency 'rake', '~> 0'
  # #spec.add_development_dependency 'redcarpet', '~> 3.5', '>= 3.5.1'
  spec.add_development_dependency 'reek', '~> 6.0', '>= 6.0.4'
  spec.add_development_dependency 'rspec', '~> 3.10'
  # This verson of rubocop is returning errors.
  # spec.add_development_dependency 'rubocop', '~> 1.14'
  spec.add_development_dependency 'rubocop', '~> 1.9.1'
  spec.add_development_dependency 'rubocop-performance', '~> 1.11', '>= 1.11.3'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.3'
  spec.add_development_dependency 'simplecov', '~> 0.21.2'

  # spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency 'rake', '~> 10.0'
  # spec.add_development_dependency "rspec", "~> 3.0"
end
