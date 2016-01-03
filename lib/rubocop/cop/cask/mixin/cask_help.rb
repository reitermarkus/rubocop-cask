module RuboCop
  module Cop
    module Cask
      # Common functionality for cops checking casks
      module CaskHelp
        def on_block(block_node)
          super if defined? super
          return unless respond_to?(:on_cask)
          return unless block_node.cask_block?

          on_cask(block_node)
        end
      end
    end
  end
end
