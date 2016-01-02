module Astrolabe
  # Extensions for Astrolabe's AST Node class
  class Node
    include RuboCop::Cask::Constants

    def_matcher :method_node, '{$(send ...) (block $(send ...) ...)}'
    def_matcher :block_args,  '(block _ $_ _)'
    def_matcher :block_body,  '(block _ _ $_)'

    def_matcher :key_node,    '{(pair $_ _) (hash (pair $_ _) ...)}'
    def_matcher :val_node,    '{(pair _ $_) (hash (pair _ $_) ...)}'

    def cask_block?
      block_type? && method_node.cask_header?
    end

    def cask_header?
      send_type? && CASK_METHOD_NAMES.include?(method_name)
    end

    def line_before
      loc.first_line - 1
    end

    def line_after
      loc.last_line + 1
    end
  end
end
