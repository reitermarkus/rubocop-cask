source 'https://rubygems.org'

gemspec

group :development do
  gem 'pry'
  gem 'pry-byebug', platforms: :mri
end

group :test do
  gem 'overcommit', '~> 0.30', require: false
  gem 'rake', '~> 10.4', require: false
  gem 'rspec', '~> 3.4', require: false
  # gem 'rubocop-rspec', '~> 1.3', require: false
  gem 'simplecov', require: false
  gem 'travis', '~> 1.8', require: false
  gem 'codeclimate-test-reporter', require: false
  gem 'net-http-persistent', '~> 2.7' # prevent errors for Ruby < 2.1
end

group :release do
  gem 'github_changelog_generator', require: false

  # prevent errors for Ruby < 2.2.2
  gem 'activesupport', '~> 4.2.7.1', require: false
  gem 'rack', '~> 1.6', require: false
end
