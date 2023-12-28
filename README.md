# DecoLite
[![Ruby](https://github.com/gangelo/deco_lite/actions/workflows/ruby.yml/badge.svg)](https://github.com/gangelo/deco_lite/actions/workflows/ruby.yml)
[![GitHub version](http://badge.fury.io/gh/gangelo%2Fdeco_lite.svg?refresh=2)](https://badge.fury.io/gh/gangelo%2Fdeco_lite)
[![Gem Version](https://badge.fury.io/rb/deco_lite.svg?refresh=2)](https://badge.fury.io/rb/deco_lite)
[![](http://ruby-gem-downloads-badge.herokuapp.com/deco_lite?type=total)](http://www.rubydoc.info/gems/deco_lite/)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/gems/deco_lite/)
[![Report Issues](https://img.shields.io/badge/report-issues-red.svg)](https://github.com/gangelo/deco_lite/issues)
[![License](http://img.shields.io/badge/license-MIT-yellowgreen.svg)](#license)

## Introduction

*DecoLite* is a little gem that allows you to use the provided `DecoLite::Model` class to dynamically create Decorator class objects. Use the `DecoLite::Model` class directly, or inherit from the `DecoLite::Model` class to create your own unique subclasses with custom functionality. `DecoLite::Model` includes `ActiveModel::Model`, so validation can be applied using [ActiveModel validation helpers](https://api.rubyonrails.org/v6.1.3/classes/ActiveModel/Validations/HelperMethods.html) you're familiar with; or, you can roll your own - just like any other `ActiveModel`.

`DecoLite::Model` allows you to consume a Ruby `Hash` that you supply via the initializer (`DecoLite::Model#new`) or via the `DecoLite::Model#load!` method. Any number of Ruby `Hashes` can be consumed. Your supplied Ruby Hashes are used to create `attr_accessor` attributes (or *"fields"*) on the model. Each attribute created is then assigned the value from the Hash that was loaded. Again, any number of hashes can be consumed using the `DecoLite::Model#load!` method.

`attr_accessors` created during initialization, or by calling `DecoLite::Model#load!`, are *mangled* to include namespacing. This allows `DecoLite` to create *unique* attribute names for nested Hashes that may have non-unique key names. For example:

```ruby
# NOTE: keys :name and :age are not unique across this Hash.
family = {
  # :name and :age are not unique
  name: 'John Doe',
  age: 35,
  wife: {
    # :name and :age are not unique
    name: 'Mary Doe',
    age: 30,
  }
}
```
Given the above example, `DecoLite` will produce the following *unique* `attr_accessors` on the `DecoLite::Model` object, and assign the values:

```ruby
# Instead of the below, you can also use DecoLite::Model.new.load!(hash: family)
model = DecoLite::Model.new(hash: family)

model.name #=> 'John Doe'
model.age #=> 35

model.wife_name #=> 'Mary Doe'
model.wife_age #=> 30
```

In the above example, notice how `DecoLite` *mangles* attributes `:wife_name` and `:wife_age` using the `:wife` `Hash` key name to make them unique.

`DecoLite::Model#load!` can be called *multiple times*, on the same model using different `Hashes`. This could potentially cause `attr_accessor` name clashes. In order to ensure unique `attr_accessor` names, a *"namespace"* may be *explicitly* provided to ensure attribute name uniqueness.

For example, **continuing from the previous example,** if we were to call `DecoLite::Model#load!` a *second time* with the following `Hash`, this would produce `attr_accessor` name clashes which would raise errors, because `:name` and `:age` attributes already exist on the `DecoLite::Model` in question:

```ruby
grandpa = {
  name: 'Henry Doe',
  age: 85,
}
```

To handle the above scenario, `DecoLite::Model` allows you to pass a `:namespace` option (for example `namespace: :grandpa`) to the `DecoLite::Model#load!` method; this would produce the following `attr_accessors`, ensuring their uniqueness:

```ruby
model.load!(hash: grandpa, options: { namespace: :grandpa })

model.grandpa_name #=> 'Henry Doe'
model.grandpa_age #=> 85

model.name #=> 'John Doe'
model.age #=> 35

model.wife_name #=> 'Mary Doe'
model.wife_age #=> 30
```

### More examples and usage

For more examples and usage, see the [Examples and usage](#examples-and-usage) and [More examples and usage](#more-examples-and-usage) sections; there is also an "I want to..." section with examples of things you may want to accomplish when using `DecoLite`.

## Use cases

### Generally Speaking
`DecoLite` would *most likely* thrive where the structure of the `Hashe(s)` consumed are (of course) known, relatively small to moderate in size, and not *terribly* deep nested-hash-wise. This is because of the way `DecoLite` mangles loaded Hash key names to create unique `attr_accessors` on the model (see the Introduction section). However, I'm sure there are some geniuses out there that would find other contexts where `DecoLite` may thrive. Assuming the former is the case, `DecoLite` would be ideal to consume Model attributes, Webservice JSON results (converted to Ruby `Hash`), JSON Web Token (JWT) payloads, etc. to create a cohesive data model to be used in any scenario.

### Rails
Because `DecoLite::Model` includes `ActiveModel::Model`, it could also be ideal for use as a model in Rails applications, where a *decorator pattern* might be used, and decorator methods provided for use in Rails views; for example:

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

Get creative. Please pop me an email and let me know how *you're* using `DecoLite`.

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

class Couple < DecoLite::Model
  def live_together?
    husband_info_address == wife_info_address
  end

  def bread_winner
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
model.bread_winner          #=> John Doe

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

Simply add your `ActiveModel` validators just like you would any other `ActiveModel::Model` validator, with one caveat noted below. It is important to note that any attribute (field) having an *explicit validation* associated with it, will automatically cause `DecoLite` to create an `attr_accessor` for that field; this is to avoid `NoMethodErrors` when validating the model (e.g. `#valid?`, `#validate`, etc.) *before* the data is loaded. Why does `DecoLite` need to do this? Typically, `DecoLite` dynamically creates `attr_accessors` using the keys from the `Hash` loaded into the model. If the `Hash` loaded into your `DecoLite` model _does not_ include a `Hash` key for the attribute referenced by any validators on your model, `DecoLite` will not create an `attr_accessor` for it; consequently, calling any validation method (e.g. `#valid?`, `#validate`, etc.) on your model will result in a `NoMethodError` for that attribute.

One caveat to note is when using Rails custom validators with `validates_with`. When using Rails custom validators via `validates_with`, you should pass the attribute names being validated to your custom validator via the `#options` `Hash` with a key of either `:attributes` or `:fields`. This is so that `DecoLite` can create dynamic `attr_accessors` for these attributes and avoid the aformentioned `NoMethodError` (see above):

```ruby
class Model < DecoLite::Model
  validates :first, :last, :address, presence: true
  validates :age, numericality: true
  # When using Rails custom validators via validates_with,
  # pass the attribute name(s) being validated in an Array
  # via the #options Hash, with a key of either :attributes
  # or :fields. For example:
  validates_with CustomFirstNameValidator, attributes: [:first]
  validates_with CustomAgeValidator, fields: [:age]
end

# :address is missing
model = Model.new(hash: { first: 'John', last: 'Doe', age: 25 })
model.respond_to? :address
#=> true

model.valid?
#=> false
model.errors.full_messages
#=> ["Address can't be blank"]

model.load!(hash: { address: '123 park road, anytown, nj 01234' })
model.valid?
#=> true
```

#### Validate whether or not certain fields were loaded

To be clear, this example does not validate the *data* associated with the fields loaded; rather, this example validates whether or not the *fields themselves* were loaded into your model, and as a result, `attr_accessors` created *for* them on the model. If you only want to validate the *data* loaded into your model, simply use `ActiveModel` validations, just like you would any other `ActiveModel` model (see the [Add validators to my model](#add-validators-to-my-model) section).

If you want to validate whether or not particular *fields* were loaded into your model, as a result of `#load!`ing data into your model, you need to add the required field names to the `DecoLite::Model#required_fields` attribute, or use inheritance:
  - Create a `DecoLite::Model` subclass.
  - Override the `DecoLite::Model#required_fields` method.
  - Return an Array of `Symbols` that represent the fields you want to validate (e.g. `%i[first last ssn]`).

For example:

```ruby
class Model < DecoLite::Model
  # :age field is optional and it's value is optional.
  validates :age, numericality: { only_integer: true }, allow_blank: true

  def required_fields
    # We want to ensure these fields were loaded.
    %i[first last address]
  end
end

model = Model.new

model.validate
#=> false

model.errors.full_messages
#=> ["First field is missing", "Last field is missing", "Address field is missing"]
```

If we load data that includes :first, :last, and :address Hash keys, even with nil data, our `":<field> field is missing"` errors would go away; in this scenario, we only wish to validate the *presence of the FIELDS,* not the data associated with these fields!

```ruby
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
#### Validate whether or not certain fields were loaded *and* validate the data associated with these same fields

If you simply want to validate the *data* loaded into your model, simply add `ActiveModel` validation, just like you would any other `ActiveModel` model (see the [Add validators to my model](#add-validators-to-my-model) section).

If you want to validate whether or not particular fields were loaded *and* the field data associated with those same fields, you simply need to return the required fields from the `DecoLite#required_fields` method and add the appropriate validation(s); for example:

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

Manually defining attributes on your subclass is possible, although there doesn't seem a valid reason to do so, since you can just use `DecoLite::Model#load!` to wire all this up for you automatically. However, if there *were* a need to do this, you must add your `attr_reader` to the `DecoLite::Model@field_names` array, or an error will be raised _provided_ there are any conflicting field names being loaded using `DecoLite::Model#load!`. Note that the aforementioned error will be raised regardless of whether or not you set `options: { fields: :merge }`. This is because `DecoLite` considers any existing model attributes *not* added to the model via `load!`*to be native to the model object,* and therefore will not allow you to create `attr_accessors` and assign values to existing model attributes because this can potentially be dangerous.

To avoid errors when manually defining model attributes that could potentially conflict with fields loaded using `DecoLite::Model#load!`, you could do the following:

```ruby
class JustBecauseYouCanDoesntMeanYouShould < DecoLite::Model
  attr_accessor :existing_field

  def initialize(hash: {}, options: {})
    # Make sure we add existing_field to @field_names before we call
    # the base class initializer.
    @field_names = %i[existing_field]

    super
  end
end

model = JustBecauseYouCanDoesntMeanYouShould.new(hash: { existing_field: :value })

model.existing_field
#=> :value
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
