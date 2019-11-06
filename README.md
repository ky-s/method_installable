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
いくつかの、あるいはすべてのメソッドを一度にインストールします。

```ruby
install_methods_from(klass, converter, *converter_args, methods: nil, follow: methods.nil?, callback: nil)
```

[args]
- klass           ... インストール元クラスオブジェクト
- converter       ... 現在のオブジェクトを klass オブジェクトに変換するメソッド
- converter_args  ... converter の引数オプション
- methods         ... インストールする対象メソッド (default: 全インスタンスメソッド)
- follow          ... 今後追加したメソッドに追随するか。
                      default は、 methods が明示的に渡されたら false 、なければ true です。
- callback        ... 処理後に実行するコールバックメソッド (Proc も可)

klass に指定した class の持つ instance_methods をレシーバクラスオブジェクトに定義します。

converter に指定したメソッドで自身を klass に変換してから対象のメソッドをコールするようになります。

自身が持っているメソッドと名称が重複した場合は自身のメソッドが優先されます。

follow を有効にすると、インストール後に追加された klass のメソッドも method_added イベントによって追随しますが、

削除、未定義にされたメソッドは追随しません。

削除されたメソッドが install_methods_from によって追加されたメソッドかどうかを判定できないためです。

### install_method_from
メソッドをひとつだけインストールします。

```ruby
install_method_from(klass, converter, *converter_args, method: , callback: nil)
```

[args]
- klass           ... インストール元クラスオブジェクト
- converter       ... 現在のオブジェクトを klass オブジェクトに変換するメソッド
- converter_args  ... converter の引数オプション
- method          ... インストールする対象メソッド
- callback        ... 処理後に実行するコールバックメソッド (Proc も可)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/method_installable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
