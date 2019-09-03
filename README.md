[![CircleCI](https://circleci.com/gh/richseviora/record-diff/tree/develop.svg?style=svg)](https://circleci.com/gh/richseviora/record-diff/tree/develop)

# Record Diff

The Record Diff gem allows you to compare and diff two enumerables using a key method. The records can also be transformed and filtered.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'record_diff'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install record_diff

## Usage

### Comparing two enumerables


### Comparing Two Hashes
```ruby
a = { unchanged: 1, dropped: 2, changed: 3}
b = { added: 1, unchanged: 1, changed: 4 }
result = RecordDiff::Matcher.diff_hash(a, b)
first_change = result.changed.first # => ResultSet::ChangedResult
first_change.id # :changed
first_change.before_compare # { unchanged: 1, dropped: 2, changed: 3}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/richseviora/record_diff. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Record Diff project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/richseviora/record_diff/blob/master/CODE_OF_CONDUCT.md).
