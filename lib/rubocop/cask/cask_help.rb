module RuboCop
  module Cask
    # Common functionality for cops checking casks
    module CaskHelp
      include NodeHelp

      CASK_METHOD_NAMES = %i(cask test_cask)

      def cask?(block_node)
        block?(block_node) && cask_method?(method_node(block_node))
      end

      def cask_method?(method_node)
        CASK_METHOD_NAMES.include?(method_name(method_node))
      end

      def cask_children(node)
        node_children(node).select { |e| cask?(e) }
      end

      def on_block(block_node)
        super if defined? super
        return unless respond_to?(:on_cask)
        return unless cask?(block_node)

        method_node, _args, block_body = *block_node

        on_cask(block_node, method_node, block_body)
      end
    end
  end
end
