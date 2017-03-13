require 'rubocop'

require 'rubocop/cask/constants'
require 'rubocop/cask/extend/string'
require 'rubocop/cask/extend/node'
require 'rubocop/cask/ast/cask_header'
require 'rubocop/cask/ast/cask_block'
require 'rubocop/cask/ast/stanza'
require 'rubocop/cask/version'
require 'rubocop/cask/inject'

RuboCop::Cask::Inject.defaults!

require 'rubocop/cop/cask/mixin/cask_help'
require 'rubocop/cop/cask/mixin/on_homepage_stanza'
require 'rubocop/cop/cask/homepage_matches_url'
require 'rubocop/cop/cask/homepage_url_trailing_slash'
require 'rubocop/cop/cask/no_dsl_version'
require 'rubocop/cop/cask/stanza_order'
require 'rubocop/cop/cask/stanza_grouping'
