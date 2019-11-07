# MethodInstallable

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/method_installable`. To experiment with that code, run `bin/console` for an interactive prompt.

The methods install to self class from other class.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'method_installable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install method_installable

## Usage

Extend MethodInstallable, and install methods.

```ruby
class Range
  extend MethodInstallable

  install_methods_from Array, :to_a
end
```

Then, you can call `Array#[]` method from Range object directly.

```ruby
(1..100)[2]  # as (1..100).to_a[2]
# => 3
```

### install_methods_from
Define `methods` from `klass` class.

```ruby
install_methods_from(klass, converter, *converter_args, methods: nil, follow: methods.nil?, callback: nil)
```
The methods implementation:
  Firstly, call `converter(*converter_args)` to convert to `klass`.
  And then, call 'installed' method from `klass`.

If self class has already the method, that is not defined.

follow:
  follow when method is added to klass.
  But not follow when method is removed or undefined.

callback:
  Proc, Method Object or method its after callback.


[args]
- klass                 ...  source class for install
- converter             ...  method for self convert to klass
- *converter_args       ...  converter method arguments
- methods: nil          ...  methods for install (default: all instance methods)
- follow: methods.nil?  ...  follow when method is added to klass
- callback: nil         ...  after callback method or procedure

### install_method_from

install only one method

```ruby
install_method_from(klass, converter, *converter_args, method: , callback: nil)
```
[args]
- klass                 ...  source class for install
- converter             ...  method for self convert to klass
- *converter_args       ...  converter method arguments
- method:               ...  method for install
- callback: nil         ...  after callback method or procedure

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/method_installable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
