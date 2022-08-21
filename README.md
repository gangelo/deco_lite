# DecoLite

[![GitHub version](http://badge.fury.io/gh/gangelo%2Fdeco.svg)](https://badge.fury.io/gh/gangelo%2Fdeco)

[![Gem Version](https://badge.fury.io/rb/deco_lite.svg)](https://badge.fury.io/rb/deco_lite)

[![](http://ruby-gem-downloads-badge.herokuapp.com/deco_lite?type=total)](http://www.rubydoc.info/gems/deco_lite/)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/gems/deco_lite/)

[![Report Issues](https://img.shields.io/badge/report-issues-red.svg)](https://github.com/gangelo/deco_lite/issues)

[![License](http://img.shields.io/badge/license-MIT-yellowgreen.svg)](#license)

## Introduction

DecoLite is in development. I wouldn't expect breaking changes before v1.0.0; however, I can't completely rule this out. Currently, DecoLite only supports Hashes whose keys are `Symbols`, contain no embedded spaces, and conform to Ruby `attr_accessor` naming conventions. However, I'll certainly work out a solution for all this in future releases.

TBD: Documentation regarding `DecoLite::Model` options, `DecoLite::Model#load` options: how these work, and how they play together (in the meantime, see the specs).

_Deco_ is a little gem that allows you to use the provided `DecoLite::Model` class (`include ActiveModel::Model`) to create Decorator classes which can be instantiated and used. Inherit from `DecoLite::Model` to create your own unique classes with custom functionality. A `DecoLite::Model` includes `ActiveModel::Model`, so validation can be applied using [ActiveModel validation helpers](https://api.rubyonrails.org/v6.1.3/classes/ActiveModel/Validations/HelperMethods.html) you are familiar with; or, you can roll your own - just like any other ActiveModel.

A `DecoLite::Model` will allow you to consume a Ruby Hash that you supply via the `DecoLite::Model#load` method. Your supplied Ruby Hashes are used to create `attr_accessor` attributes (_"fields"_) on the model. Each attribute created, is then assigned its value from the Hash loaded.

`attr_accessor` names created are _mangled_ to include namespacing. This creates unique attribute names for nested Hashes that may include non-unique keys. For example:

```ruby
# NOTE: keys :name and :age are not unique across this Hash.
{
  name: 'John Doe',
  age: 35,
  wife: {
    name: 'Mary Doe',
    age: 30,
  }
}
```
Given the above example, DecoLite will produce the following `attr_accessors` on the `DecoLite::Model` object when loaded (`DecoLite::Model#load`), and assign the values:

```ruby
name=, name #=> 'John Doe'
age=, age #=> 35
wife_name=, wife_name #=> 'Mary Doe'
wife_age=, wife_age #=> 30
```

`DecoLite::Model#load` can be called _multiple times_, on the same model, with different Hashes. This could potentially cause `attr_accessor` name clashes. In order to ensure unique `attr_accessor` names, a _"namespace"_ may be _explicitly_ provided to ensure uniqueness. For example, continuing from the previous example; if we were to call `DecoLite::Model#load` a _second time_ with the following Hash, it would produce `attr_accessor` name clashes:

```ruby
{
  name: 'Henry Doe',
  age: 85,
}
```

However, passing a `namespace: :grandpa` option to the `DecoLite::Model#load` method, would produce the following `attr_accessors`, ensuring uniquess:
```ruby
# Unique now that the namespace "grandpa" has been applied.
grandpa_name=, grandpa_name #=> 'Henry Doe'
grandpa_age=, grandpa_age #=> 85
```
## Use Cases

### General
_Deco_ would _most likely_ thrive where the structure of the Hashe(s) consumed by the `DecoLite::Model#load` method is known. This is because of the way _Deco_ mangles loaded Hash key names to create unique `attr_accessor` names (see the Introduction section) although, I'm sure there are some metaprogramming geniuses out there that might prove me wrong. Assuming this is the case, _Deco_ would be ideal to handle Model attributes, Webservice JSON results (converted to Ruby Hash), JSON Web Token (JWT) payload, etc..

### Rails
Because `DecoLite::Model` includes `ActiveModel::Model`, it could also be ideal for use as a model in Rails applications, where a _decorator pattern_ can be used, and methods provided for use in Rails views; for example:

```ruby
class ViewModel < DecoLite::Model
  validates :first, :last, presence: true

  def salutation
    "<span class='happy'>Hello <em>#{full_name}<em>, welcome back!</span>"
  end

  def full_name
    "#{first} #{last}"
  end
end

view_model = ViewModel.new

view_model.load(hash: { first: 'John', last: 'Doe' })

view_model.valid?
#=> true

view_model.full_name
=> "John Doe"

view_model.salutation
=> "<span class='happy'>Hello <em>John Doe<em>, welcome back!</span>"
```
### Etc., etc., etc.

Get creative. Please pop me an email and let me know how _you're_ using _Deco_.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deco_lite'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deco_lite

## Examples and Usage

```ruby
require 'deco_lite'

husband = {
  name: 'John Doe',
  info: {
    age: 21,
    address: '1 street, boonton, nj 07005',
    salary: 100_000,
  },
}

wife = {
  name: 'Mary Doe',
  info: {
    age: 20,
    address: '1 street, boonton, nj 07005',
    salary: 90_000,
  },
}

class Couple < DecoLite::Model)
  def live_together?
    husband_info_address == wife_info_address
  end

  def breadwinner
    case
    when husband_info_salary > wife_info_salary
      husband_name
    when husband_info_salary < wife_info_salary
      wife_name
    else
      "#{husband_name} and #{wife_name} make the same amount"
    end
  end
end

couple = Couple.new

couple.load(hash: husband, options: { namespace: :husband })
couple.load(hash: wife, options: { namespace: :wife })

# Will produce the following:
model.live_together?        #=> true
model.breadwinner           #=> John Doe

model.husband_name          #=> John Doe
model.husband_info_age      #=> 21
model.husband_info_address  #=> 1 street, boonton, nj 07005

model.wife_name             #=> Amy Doe
model.wife_info_age         #=> 20
model.wife_info_address     #=> 1 street, boonton, nj 07005
```

### Manually Defining Attributes

Manually defining attributes on your subclass is possible; however, you
must add your attr_reader name to the `DecoLite::Model@field_names` array, or an error will be reaised _if_ there are any conflicting field names being loaded
using `DecoLite::Model#load!`, regardless of setting the `{ fields: :merge }`
option. This is because DecoLite assumes any existing attributes not added to
the model via `load!`to be native to the object created, and therefore will not
allow you to create attr_accessors for existing attributes, as this can potentially be dangerous.

To avoid errors when manually defining attributes on the model that could potentially be in conflict with fields loaded using `DecoLite::Model#load!`, do the following:

```ruby
class JustBecauseYouCanDoesntMeanYouShould < DecoLite::Model
  attr_accessor :existing_field

  def initialize(options: {})
    super

    @field_names = %i(existing_field)
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/deco_lite. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DecoLite project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/deco_lite/blob/master/CODE_OF_CONDUCT.md).
