require 'rubocop'
require 'rubocop/rspec/support'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

project_path = File.join(File.dirname(__FILE__), '..')
Dir["#{project_path}/spec/support/**/*.rb"].each do |f|
  require f
end

RSpec.configure do |config|
  config.order = :random

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect # Disable `should`
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect # Disable `should_receive` and `stub`
  end
end

$LOAD_PATH.unshift(File.join(__dir__, '..', 'lib'))
require 'rubocop-cask'
