require 'rubocop'

require 'rubocop/cask/cask_block'
require 'rubocop/cask/version'
require 'rubocop/cask/inject'

RuboCop::Cask::Inject.defaults!

require 'rubocop/cop/cask/no_dsl_version'
