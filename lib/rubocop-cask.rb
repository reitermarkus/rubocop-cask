require 'rubocop'

require 'rubocop/cask/node_help'
require 'rubocop/cask/cask_help'
require 'rubocop/cask/cask_header'
require 'rubocop/cask/cask_block'
require 'rubocop/cask/version'
require 'rubocop/cask/inject'

RuboCop::Cask::Inject.defaults!

require 'rubocop/cop/cask/no_dsl_version'
