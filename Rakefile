require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'github_changelog_generator/task'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

RSpec::Core::RakeTask.new(:spec)

desc 'Run RSpec with code coverage'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
end

RuboCop::RakeTask.new

task default: [:spec, :rubocop]

desc 'Open a REPL for experimentation'
task :repl do
  require 'pry'
  require 'rubocop-cask'
  ARGV.clear
  RuboCop.pry
end

GitHubChangelogGenerator::RakeTask.new(:changelog) do |config|
  config.user = 'caskroom'
  config.project = 'rubocop-cask'
  config.exclude_labels = %w(discussion duplicate invalid question wontfix)
end
