# Deco

Deco is a work in process (WIP)

_Deco_ is a little gem that allows you to use the provided `Deco::Model` class (`include ActiveModel::Model`) to create Decorator objects which allow you to load (`Deco::Model#load`) your supplied Ruby Hashes. Your supplied Ruby Hashes are used to create `attr_accessor` attributes (_"fields"_) on the model. Each attribute created is then assigned its value from the Hash that was loaded.

`attr_accessor` names created are _mangled_ to form (where possible) unique attribute names. If unique attribute names cannot be achieved, a _"namespace"_ can be provided; for example: 

```ruby
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

require 'deco'

couple = Class.new(Deco::Model) do
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
         end.new

couple.load(hash: husband, options: { namespace: :husband })
couple.load(hash: wife, options: { namespace: :wife })

# Will produce the following:
model.live_together?        #=> true
model.breadwinner           #=> John Doe

model.husband_name          #=> John Doe
model.husband_info_age      #=> 21
model.husband_info_address  #=> 1 street, boonton, nj 07005

model.wife_name          #=> Amy Doe
model.wife_info_age      #=> 20
model.wife_info_address  #=> 1 street, boonton, nj 07005
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deco'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deco

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/deco. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Deco project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/deco/blob/master/CODE_OF_CONDUCT.md).
