# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deco_lite/version'

Gem::Specification.new do |spec|
  spec.name          = 'deco_lite'
  spec.version       = DecoLite::VERSION
  spec.authors       = ['Gene M. Angelo, Jr.']
  spec.email         = ['public.gma@gmail.com']

  spec.summary       = 'Dynamically creates an active model from a Hash.'
  spec.description   = <<-EOF
    DecoLite is a little gem that allows you to use the provided DecoLite::Model
    class to dynamically create Decorator class objects. Use the DecoLite::Model
    class directly, or inherit from the DecoLite::Model class to create your own
    unique subclasses with custom functionality. DecoLite::Model
    includes ActiveModel::Model, so validation can be applied using ActiveModel
    validation helpers (https://api.rubyonrails.org/v6.1.3/classes/ActiveModel/Validations/HelperMethods.html)
    you're familiar with; or, you can roll your own - just like any other ActiveModel.

    DecoLite::Model allows you to consume a Ruby Hash that you supply via the
    initializer (DecoLite::Model#new) or via the DecoLite::Model#load! method. Any
    number of Ruby Hashes can be consumed. Your supplied Ruby Hashes are used to
    create attr_accessor attributes (or "fields") on the model. Each attribute
    created is then assigned the value from the Hash that was loaded. Again, any
    number of hashes can be consumed using the DecoLite::Model#load! method.
  EOF
  spec.homepage      = 'https://github.com/gangelo/deco_lite'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise 'RubyGems 2.0 or newer is required to protect against ' \
  #     'public gem pushes.'
  # end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 3.0.1', '< 4.0')

  spec.add_runtime_dependency 'activemodel', '>= 7.0.8', '<= 7.12.0'
  spec.add_runtime_dependency 'activesupport', '>= 7.0.8', '<= 7.12.0'
  spec.add_runtime_dependency 'immutable_struct_ex', '>= 1.0', '< 2.0'
  spec.add_runtime_dependency 'mad_flatter', '>= 3.0', '< 4.0'
  spec.post_install_message = <<~POST_INSTALL
    Thank you for installing deco_lite.

    View the deco_lite README.md here: https://github.com/gangelo/deco_lite
    View the deco_lite CHANGELOG.md: https://github.com/gangelo/deco_lite/blob/main/CHANGELOG.md

                *
              ***
            *******
            *********
    ***********************
        *****************
          *************
        ******* *******
        *****       *****
      ***             ***
      **                 **

    Using deco_lite? deco_lite is made available free of charge. Please consider giving this gem a STAR on GitHub as well as sharing it with your fellow developers on social media.

    Knowing that deco_lite is being used and appreciated is a great motivator to continue developing and improving deco_lite.

    >>> Star it on github: https://github.com/gangelo/deco_lite
    >>> Share on social media: https://rubygems.org/gems/deco_lite

    Thank you!

    <3 Gene
  POST_INSTALL
end
