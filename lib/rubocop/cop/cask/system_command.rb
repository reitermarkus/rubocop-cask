require 'forwardable'

module RuboCop
  module Cop
    module Cask
      # This cop checks that a cask uses system_command
      # instead of system.
      class SystemCommand < Cop
        extend Forwardable
        include CaskHelp

        def on_cask(cask_block)
          @cask_block = cask_block
          # puts cask_block
        end
      end
    end
  end
end
