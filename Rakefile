require 'bundler/gem_tasks'
require 'github_changelog_generator/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Run RSpec with code coverage'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
end

RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ['--force-exclusion']
end

task default: [:spec, :rubocop]

desc 'Open a REPL for experimentation'
task :repl do
  require 'pry'
  ARGV.clear
  RuboCop.pry
end

namespace :changelog do
  def configure_changelog(config, release: nil)
    config.user = 'caskroom'
    config.project = 'rubocop-cask'
    config.exclude_labels = %w[discussion duplicate invalid question wontfix]
    config.future_release = "v#{release}" if release
  end

  GitHubChangelogGenerator::RakeTask.new(:unreleased) do |config|
    configure_changelog(config)
  end

  GitHubChangelogGenerator::RakeTask.new(:latest_release) do |config|
    require 'rubocop/cask/version'
    configure_changelog(config, release: RuboCop::Cask::Version::STRING)
  end
end

task changelog: 'changelog:unreleased'

Rake::Task['build'].enhance [:spec, 'rubocop:auto_correct',
                             'changelog:latest_release']
