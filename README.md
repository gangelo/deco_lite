# DecoLite

[![GitHub version](http://badge.fury.io/gh/gangelo%2Fdeco.svg)](https://badge.fury.io/gh/gangelo%2Fdeco)

[![Gem Version](https://badge.fury.io/rb/deco_lite.svg)](https://badge.fury.io/rb/deco_lite)

[![](http://ruby-gem-downloads-badge.herokuapp.com/deco_lite?type=total)](http://www.rubydoc.info/gems/deco_lite/)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/gems/deco_lite/)

[![Report Issues](https://img.shields.io/badge/report-issues-red.svg)](https://github.com/gangelo/deco_lite/issues)

[![License](http://img.shields.io/badge/license-MIT-yellowgreen.svg)](#license)

## Introduction

DecoLite is in development. I wouldn't expect breaking changes before v1.0.0; however, I can't completely rule this out. Currently, DecoLite only supports Hashes whose keys are `Symbols`, contain no embedded spaces, and conform to Ruby `attr_accessor` naming conventions. However, I'll certainly work out a solution for all this in future releases.

TBD: Documentation regarding `DecoLite::Model` options, `DecoLite::Model#load!` options: how these work, and how they play together (in the meantime, see the specs).

_Deco_ is a little gem that allows you to use the provided `DecoLite::Model` class (`include ActiveModel::Model`) to create Decorator classes which can be instantiated and used. Inherit from `DecoLite::Model` to create your own unique classes with custom functionality. A `DecoLite::Model` includes `ActiveModel::Model`, so validation can be applied using [ActiveModel validation helpers](https://api.rubyonrails.org/v6.1.3/classes/ActiveModel/Validations/HelperMethods.html) you are familiar with; or, you can roll your own - just like any other ActiveModel.

A `DecoLite::Model` will allow you to consume a Ruby Hash that you supply via the `DecoLite::Model#load!` method. Your supplied Ruby Hashes are used to create `attr_accessor` attributes (_"fields"_) on the model. Each attribute created, is then assigned its value from the Hash loaded.

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
Given the above example, DecoLite will produce the following `attr_accessors` on the `DecoLite::Model` object when loaded (`DecoLite::Model#load!`), and assign the values:

```ruby
model = DecoLite::Model.new.load!(hash: family)

model.name #=> 'John Doe'
model.respond_to? :name= #=> true

model.age #=> 35
model.respond_to? :age= #=> true

model.wife_name #=> 'Mary Doe'
model.respond_to? :wife_name= #=> true

model.wife_age #=> 30
model.respond_to? :wife_age= #=> true
```

`DecoLite::Model#load!` can be called _multiple times_, on the same model, with different Hashes. This could potentially cause `attr_accessor` name clashes. In order to ensure unique `attr_accessor` names, a _"namespace"_ may be _explicitly_ provided to ensure uniqueness. For example, continuing from the previous example; if we were to call `DecoLite::Model#load!` a _second time_ with the following Hash, it would produce `attr_accessor` name clashes:

```ruby
grandpa = {
  name: 'Henry Doe',
  age: 85,
}
# The :name and :age Hash keys above will produce :name/:name= and :age/:age= attr_accessors and clash because these were already added to the model when "John Doe" was loaded with the first call to DecoLite::Model#load!.
```

However, passing a `namespace:` option (for example `namespace: :grandpa`) to the `DecoLite::Model#load!` method, would produce the following `attr_accessors`, ensuring their uniqueness:

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

view_model = ViewModel.new

view_model.load!(hash: { first: 'John', last: 'Doe' })

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

Simply add your `ActiveModel` validators just like you would any other `ActiveModel::Model` validator. However, be aware that (currently), any attribute (field) having an _explicit validation_ associated with it, will automatically cause an `attr_accessor` to be created for that field; this is to avoid `NoMethodErrors` when calling a validation method on the model (e.g. `#valid?`, `#validate`, etc.):

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

To be clear, this has nothing to do with the _data_ associated with the fields loaded; rather, this has to do with whether or not the _fields themselves_ were created as attributes on your model as a result of loading data into your model. If you simply want to validate the _data_ loaded into your model, simply add `ActiveModel` validation, just like you would any other `ActiveModel` model, see the [Add validators to my model](#add-validators-to-my-model) section.

If you want to validate whether or not particular _fields_ were added to your model as attributes (i.e. `attr_accessor`), as a result of `#load!`ing data into your model, you need to do a few things:
  - Create a `DecoLite::Model` subclass.
  - Override the `DecoLite::Model#required_fields` method to return the field names you want to validate.
  - Use the `required_fields: nil` option when instantiating your model object.
  - DO NOT add `ActiveModel` validators that _explicitly_ reference any field returned from `DecoLite::Model#required_fields`; this will cause `attr_accessors` to be created for these fields; consequently, `DecoLite::FieldRequireable#validate_required_fields` will _never_ return any errors because these fields will exist as attributes on your model. In other words, do not add `validates :first, :last, :address, presence: true` to your model if you need to validate whether or not the data you load into your model included fields :first, :last and :address.

For example:

```ruby
class Model < DecoLite::Model
  # :age field is optional and it's value is optional.
  validates :age, numericality: { only_integer: true }, allow_blank: true

  def required_fields
    # We want to ensure attr_accessors are created for these fields.
    %i(first last address)
  end
end

# Option "required_fields: :auto" is the default which will automatically create
# attr_accessors for fields returned from DecoLite::Model#required_fields, so we
# need to set this option to nil (i.e. required_fields: nil).
model = Model.new(options: { required_fields: nil })

model.validate
#=> false
model.errors.full_messages
#=> ["First field is missing", "Last field is missing", "Address field is missing"]

user = { first: 'John', last: 'Doe', address: '123 anystreet, anytown, nj 01234'}
model.load!(hash: user)
model.validate
#=> false
model.errors.full_messages
#=> ["Age is not a number"]
```
#### Validate whether or not certain fields were loaded _and_ validate the data associated with these same fields

If you simply want to validate the _data_ loaded into your model, simply add `ActiveModel` validation, just like you would any other `ActiveModel` model, see the [Add validators to my model](#add-validators-to-my-model) section.

If you want to validate whether or not particular fields were loaded _and_ field data associated with these same fields, you'll have to use custom validation (e.g. override `DecoLite::FieldRequireable#validate_required_fields` and manually add your own validation and errors). This is because `DecoLite::Model#new` will automatically create `attr_accessors` for any attribute (field) that has an _explicit_ `ActiveModel` validation associated with it, and return false positives when you validate your model. In addition to this, you will need to do several other things outlined in the [Validate whether or not certain fields were loaded](#validate-whether-or-not-certain-fields-were-loaded) section.

For example:

```ruby
class Model < DecoLite::Model
  def required_fields
    %i(first last address age)
  end

  def validate_required_fields
    super

    first = self.try(:first)
    errors.add(:first, "can't be blank") if first.nil?

    last = self.try(:last)
    errors.add(:last, "can't be blank") if last.nil?

    address = self.try(:address)
    errors.add(:address, "can't be blank") if address.nil?

    age = self.try(:age)
    errors.add(:age, "can't be blank") if age.nil?
    errors.add(:age, 'is not a number') unless /\d+/ =~ age
  end
end
model = Model.new(options: { required_fields: nil })

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

    @field_names = %i(existing_field)
  end
end
```

However, the above is unnecessary as this can be easily accomplished using `DecoLite::Model#load!`:
```ruby
model = Class.new(DecoLite::Model).new.load!(hash:{ existing_field: :existing_field_value })

model.field_names
#=> [:existing_field]

model.existing_field
#=> :existing_field_value

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
