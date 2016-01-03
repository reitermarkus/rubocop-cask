require 'forwardable'

module RuboCop
  module Cask
    module AST
      # This class wraps the AST send node that encapsulates the method call
      # that comprises the stanza. It includes various helper methods to aid
      # cops in their analysis.
      class Stanza
        extend Forwardable

        def initialize(method_node)
          @method_node = method_node
        end

        attr_reader :method_node

        alias_method :stanza_node, :method_node

        def_delegator :stanza_node, :method_name, :stanza_name
        def_delegator :stanza_node, :parent, :parent_node

        def expression
          stanza_node.expression
        end

        def_delegator :expression, :source

        def stanza_group
          Constants::STANZA_GROUP_HASH[stanza_name]
        end

        def same_group?(other)
          stanza_group == other.stanza_group
        end

        def toplevel_stanza?
          parent_node.parent.cask_block?
        end

        def ==(other)
          self.class == other.class && stanza_node == other.stanza_node
        end

        alias_method :eql?, :==

        Constants::STANZA_ORDER.each do |stanza_name|
          class_eval <<-EOS, __FILE__, __LINE__
            def #{stanza_name}?
              stanza_name == :#{stanza_name}
            end
          EOS
        end
      end
    end
  end
end
