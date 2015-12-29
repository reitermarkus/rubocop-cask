module RuboCop
  module Cask
    # This class wraps the AST block node that represents the entire cask
    # definition. It includes various helper methods to aid cops in their
    # analysis.
    class CaskBlock
      include CaskHelp

      attr_reader :block_node

      def initialize(block_node)
        @block_node = block_node
      end

      def header
        @header ||= CaskHeader.new(method_node(block_node))
      end
    end
  end
end
