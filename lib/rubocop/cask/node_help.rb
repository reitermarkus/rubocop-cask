module RuboCop
  module Cask
    # Helpers for traversing AST nodes
    module NodeHelp
      def root_node
        processed_source.ast
      end

      def node?(node, type: nil)
        return unless node.is_a?(Parser::AST::Node)
        type ? node.type == type : true
      end

      def method?(node)
        node?(node, type: :send)
      end

      def block?(node)
        node?(node, type: :block)
      end

      def hash?(node)
        node?(node, type: :hash)
      end

      def pair?(node)
        node?(node, type: :pair)
      end

      def node_children(node, type: nil)
        node.children.select { |e| node?(e, type: type) }
      end

      def method_children(node)
        node_children(node, type: :send)
      end

      def block_children(node)
        node_children(node, type: :block)
      end

      def hash_children(node)
        node_children(node, type: :hash)
      end

      def pair_children(node)
        node_children(node, type: :pair)
      end

      def method_node(block_node)
        fail 'Not a block node' unless block?(block_node)
        method_node, _args, _body = *block_node
        method_node
      end

      def method_name(method_node)
        fail 'Not a send node' unless method?(method_node)
        _receiver, method_name, *_method_args = *method_node
        method_name
      end

      def method_args(method_node)
        fail 'Not a send node' unless method?(method_node)
        _receiver, _method_name, *method_args = *method_node
        method_args
      end

      def key_node(pair_node)
        fail 'Not a pair node' unless pair?(pair_node)
        key_node, _value_node = *pair_node
        key_node
      end

      def value_node(pair_node)
        fail 'Not a pair node' unless pair?(pair_node)
        _key_node, value_node = *pair_node
        value_node
      end
    end
  end
end
