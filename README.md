# Utf8mb4rails

A simple gem that adds a rake task to deal with utf8 to utf8mb4 migrations for mysql.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'utf8mb4rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install utf8mb4rails

## Usage

This gem will add in your rails project a new task called utf8mb4. This tast is aimed to easily convert tables in utf8 into
utf8mb4 without truncating column contents and maintaining its original schema (without changing max sizes).

**USE AT YOUR OWN RISK!!!**

    $ rake -T

```
...
rake db:utf8mb4                          # migrates a table[/column] (TABLE, COLUMN env vars) to utf8mb encoding
...

```

You can modify its behavior using env vars.

- **TABLE**: The table you want to migrate, if no column is specified every single column will be migrated, also the default charset
of the table is altered.
- **COLUMN**: The column to be migrated (needs TABLE defined). It will only migrate that column definition.
- **COLLATION**: The collation (utf8mb4_unicode_520_ci by default)


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/magec/utf8mb4rails.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

