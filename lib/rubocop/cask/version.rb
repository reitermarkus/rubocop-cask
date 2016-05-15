require 'rubygems'

module RuboCop
  module Cask
    # Version information for the Cask RuboCop plugin.
    module Version
      STRING = '0.6.0'

      def self.gem_version
        Gem::Version.new(STRING)
      end
    end
  end
end
