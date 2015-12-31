# RuboCop Cask

[![Gem Version](https://badge.fury.io/rb/rubocop-cask.svg)](http://badge.fury.io/rb/rubocop-cask)
[![Dependency Status](https://gemnasium.com/caskroom/rubocop-cask.svg)](https://gemnasium.com/caskroom/rubocop-cask)
[![Build Status](https://travis-ci.org/caskroom/rubocop-cask.svg?branch=master)](https://travis-ci.org/caskroom/rubocop-cask)
[![Coverage Status](https://img.shields.io/codeclimate/coverage/github/caskroom/rubocop-cask.svg)](https://codeclimate.com/github/caskroom/rubocop-cask)
[![Code Climate](https://codeclimate.com/github/caskroom/rubocop-cask/badges/gpa.svg)](https://codeclimate.com/github/caskroom/rubocop-cask)
[![Inline docs](http://inch-ci.org/github/caskroom/rubocop-cask.svg)](http://inch-ci.org/github/caskroom/rubocop-cask)

Cask-specific analysis for your Homebrew-Cask taps, as an extension to
[RuboCop](https://github.com/bbatsov/rubocop). Heavily inspired by [`rubocop-rspec`](https://github.com/nevir/rubocop-rspec).


## Installation

Just install the `rubocop-cask` gem

```bash
gem install rubocop-cask
```

or if you use bundler put this in your `Gemfile`

```
gem 'rubocop-cask'
```


## Usage

You need to tell RuboCop to load the Cask extension. There are three ways to do this:

### RuboCop configuration file

Put this into your `.rubocop.yml`:

```
require: rubocop-cask
```

Now you can run `rubocop` and it will automatically load the RuboCop Cask cops together with the standard cops.

### Command line

```bash
rubocop --require rubocop-cask
```

### Rake task

```ruby
RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-cask'
end
```


## The Cops

All cops are located under [`lib/rubocop/cop/cask`](lib/rubocop/cop/cask), and contain examples/documentation.

In your `.rubocop.yml`, you may treat the Cask cops just like any other cop. For example:

```yaml
Cask/NoDslVersion:
  Enabled: false
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

For running the spec files, this project depends on RuboCop's spec helpers. This means that in order to run the specs locally, you need a (shallow) clone of the RuboCop repository:

```bash
git submodule update --init --depth 1 vendor/rubocop
```

## License

`rubocop-cask` is MIT licensed. [See the accompanying file](MIT-LICENSE.md) for
the full text.
