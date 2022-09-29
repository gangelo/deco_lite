# DecoLite

[![GitHub version](http://badge.fury.io/gh/gangelo%2Fdeco.svg)](https://badge.fury.io/gh/gangelo%2Fdeco)

[![Gem Version](https://badge.fury.io/rb/deco_lite.svg)](https://badge.fury.io/rb/deco_lite)

[![](http://ruby-gem-downloads-badge.herokuapp.com/deco_lite?type=total)](http://www.rubydoc.info/gems/deco_lite/)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/gems/deco_lite/)

[![Report Issues](https://img.shields.io/badge/report-issues-red.svg)](https://github.com/gangelo/deco_lite/issues)

[![License](http://img.shields.io/badge/license-MIT-yellowgreen.svg)](#license)

## Introduction

_Deco_ is a little gem that allows you to use the provided `DecoLite::Model` class (`include ActiveModel::Model`) to dynamically create Decorator class objects. Inherit from `DecoLite::Model` to create your own unique classes with custom functionality. A `DecoLite::Model` includes `ActiveModel::Model`, so validation can be applied using [ActiveModel validation helpers](https://api.rubyonrails.org/v6.1.3/classes/ActiveModel/Validations/HelperMethods.html) you are familiar with; or, you can roll your own - just like any other ActiveModel.

A `DecoLite::Model` will allow you to consume a Ruby Hash that you supply via the initializer (`DecoLite::Model#new`) or via the `DecoLite::Model#load!` method. Your supplied Ruby Hashes are used to create `attr_accessor` attributes (_"fields"_) on the model. Each attribute created, is then assigned its value from the Hash loaded. Any number of hashes can be consumed using the `DecoLite::Model#load!` method.

`attr_accessor` names created are _mangled_ to include namespacing. This creates unique attribute names for nested Hashes that may include non-unique keys. For example:

```ruby
# NOTE: keys :name and :age are not unique across this Hash.
family = {
  name: 'John Doe',
  age: 35,
  wife: {
    name: 'Mary Doe',
    age: 30,
  }
}
```
Given the above example, DecoLite will produce the following `attr_accessors` on the `DecoLite::Model` object and assign the values:

```ruby
# Or DecoLite::Model.new.load!(hash: family)
model = DecoLite::Model.new(hash: family)

model.name #=> 'John Doe'
model.respond_to? :name= #=> true

model.age #=> 35
model.respond_to? :age= #=> true

model.wife_name #=> 'Mary Doe'
model.respond_to? :wife_name= #=> true

model.wife_age #=> 30
model.respond_to? :wife_age= #=> true
```

`DecoLite::Model#load!` can be called _multiple times_, on the same model, with different Hashes. This could potentially cause `attr_accessor` name clashes. In order to ensure unique `attr_accessor` names, a _"namespace"_ may be _explicitly_ provided to ensure uniqueness.

For example, **continuing from the previous example;** if we were to call `DecoLite::Model#load!` a _second time_ with the following Hash, this would potentially produce `attr_accessor` name clashes:

```ruby
grandpa = {
  name: 'Henry Doe',
  age: 85,
}
# The :name and :age Hash keys above will produce :name/:name= and :age/:age= attr_accessors
# and clash because these were already added to the model when "John Doe" was loaded with
# the first call to DecoLite::Model.new(hash: family).
```

However, passing a `:namespace` option (for example `namespace: :grandpa`) to the `DecoLite::Model#load!` method, would produce the following `attr_accessors`, ensuring their uniqueness:

```ruby
model.load!(hash: grandpa, options: { namespace: :grandpa })

# Unique now that the namespace: :grandpa has been applied:
model.grandpa_name #=> 'Henry Doe'
model.respond_to? :grandpa_name= #=> true

model.grandpa_age #=> 85
model.respond_to? :grandpa_age= #=> true

# All the other attributes on the model remain the same, and unique:
model.name #=> 'John Doe'
model.respond_to? :name= #=> true

model.age #=> 35
model.respond_to? :age= #=> true

model.wife_name #=> 'Mary Doe'
model.respond_to? :wife_name= #=> true

model.wife_age #=> 30
model.respond_to? :wife_age= #=> true
```

### For more examples and usage

For more examples and usage, see the [Examples and usage](#examples-and-usage) and [Mode examples and usage](#more-examples-and-usage) sections; there is also an "I want to..." section with examples you might encounter when using `DecoLite`.

## Use cases

### General
_Deco_ would _most likely_ thrive where the structure of the Hashe(s) consumed by the `DecoLite::Model#load!` method is known. This is because of the way _Deco_ mangles loaded Hash key names to create unique `attr_accessor` names (see the Introduction section); although, I'm sure there are some metaprogramming geniuses out there that might prove me wrong. Assuming this is the case, _Deco_ would be ideal to handle Model attributes, Webservice JSON results (converted to Ruby Hash), JSON Web Token (JWT) payload, etc..

### Rails
Because `DecoLite::Model` includes `ActiveModel::Model`, it could also be ideal for use as a model in Rails applications, where a _decorator pattern_ might be used, and decorator methods provided for use in Rails views; for example:

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

view_model = ViewModel.new(hash: { first: 'John', last: 'Doe' })

view_model.valid?
#=> true

view_model.full_name
=> "John Doe"

view_model.salutation
=> "<span class='happy'>Hello <em>John Doe<em>, welcome back!</span>"
```
### Etc., etc., etc.

Get creative. Please pop me an email and let me know how _you're_ using _Deco_.

## Examples and usage

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

couple.load!(hash: husband, options: { namespace: :husband })
couple.load!(hash: wife, options: { namespace: :wife })

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
## More examples and usage

### I want to...

#### Add validators to my model

Simply add your `ActiveModel` validators just like you would any other `ActiveModel::Model` validator. However, be aware that (currently), any attribute (field) having an _explicit validation_ associated with it, will automatically cause an `attr_accessor` to be created for that field; this is to avoid `NoMethodErrors` when calling a validation method on the model (e.g. `#valid?`, `#validate`, etc.) *before* the data is loaded to create the associated `attr_accessors`:

```ruby
class Model < DecoLite::Model
  validates :first, :last, :address, presence: true
  validates :age, numericality: true
end

# No :address
model = Model.new(hash: { first: 'John', last: 'Doe', age: 25 })
model.respond_to? :address
#=> true

model.valid?
#=> false
model.errors.full_messages
#=> ["Address can't be blank"]

model.load!(hash: { address: '123 park road, anytown, nj 01234' })
model.validate
#=> true
```

#### Validate whether or not certain fields were loaded

To be clear, this example does not validate the _data_ associated with the fields loaded; rather, this example validates whether or not the _fields themselves_ were loaded into your model, and as a result, `attr_accessors` created. If you only want to validate the _data_ loaded into your model, simply add `ActiveModel` validation, just like you would any other `ActiveModel` model, see the [Add validators to my model](#add-validators-to-my-model) section.

If you want to validate whether or not particular _fields_ were added to your model as attributes (`attr_accessor`), as a result of `#load!`ing data into your model, you need to add the required field names to the `DecoLite::Model#required_fields` attribute, or use inheritance:
  - Create a `DecoLite::Model` subclass.
  - Override the `DecoLite::Model#required_fields` method and return an Array of field names represented by `Symbols` you want to validate.

For example:

```ruby
class Model < DecoLite::Model
  # :age field is optional and it's value is optional.
  validates :age, numericality: { only_integer: true }, allow_blank: true

  def required_fields
    # We want to ensure these fields were included as Hash keys during loading.
    %i[first last address]
  end
end

model = Model.new

model.validate
#=> false
model.errors.full_messages
#=> ["First field is missing", "Last field is missing", "Address field is missing"]

# If we load data that includes :first, :last, and :address Hash keys even with
# nil data, our ":<field> field is missing" errors go away; in this scenario,
# we're validating the presence of the FIELDS, not the data associated with
# these fields!
model.load!(hash: { first: nil, last: nil, address: nil })
model.validate
#=> true
model.errors.full_messages
#=> []

user = {
  first: 'John',
  last: 'Doe',
  address: '123 anystreet, anytown, nj 01234',
  age: 'x'
}
model.load!(hash: user)
model.validate
#=> false
model.errors.full_messages
#=> ["Age is not a number"]
```
#### Validate whether or not certain fields were loaded _and_ validate the data associated with these same fields

If you simply want to validate the _data_ loaded into your model, simply add `ActiveModel` validation, just like you would any other `ActiveModel` model, see the [Add validators to my model](#add-validators-to-my-model) section.

If you want to validate whether or not particular fields were loaded _and_ field data associated with these same fields, you simply need to add the required fields and any other validation(s).

For example:

```ruby
class Model < DecoLite::Model
  validates :first, :last, :address, :age, presence: true

  def required_fields
    %i[first last address age]
  end
end
model = Model.new

model.validate
#=> false

model.errors.full_messages
#=> ["First field is missing",
 "Last field is missing",
 "Address field is missing",
 "Age field is missing",
 "First can't be blank",
 "Last can't be blank",
 "Address can't be blank",
 "Age can't be blank",
 "Age is not a number"]
```

#### Manually define attributes (fields) on my model

Manually defining attributes on your subclass is possible, although there doesn't seem a valid reason to do so, since you can just use `DecoLite::Model#load!` to wire all this up for you automatically. However, if there _were_ a need to do this, you must add your `attr_reader` to the `DecoLite::Model@field_names` array, or an error will be raised _provided_ there are any conflicting field names being loaded using `DecoLite::Model#load!`. Note that the aforementioned error will be raised regardless of whether or not you set `options: { fields: :merge }`. This is because DecoLite considers any existing model attributes _not_ added to the model via `load!`to be native to the model object, and therefore will not allow you to create attr_accessors for existing model attributes because this can potentially be dangerous.

To avoid errors when manually defining model attributes that could potentially conflict with fields loaded using `DecoLite::Model#load!`, do the following:

```ruby
class JustBecauseYouCanDoesntMeanYouShould < DecoLite::Model
  attr_accessor :existing_field

  def initialize(options: {})
    super

    @field_names = %i[existing_field]
  end
end
```

However, the above is unnecessary as this can be easily accomplished by passing a `Hash` to the initializer or by using `DecoLite::Model#load!`:

```ruby
model = Class.new(DecoLite::Model).new(hash:{ existing_field: :value })

model.field_names
#=> [:existing_field]

model.existing_field
#=> :value

model.respond_to? :existing_field=
#=> true
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deco_lite'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deco_lite

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/deco_lite. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DecoLite project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/deco_lite/blob/master/CODE_OF_CONDUCT.md).
