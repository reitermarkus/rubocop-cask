module RuboCop
  module Cask
    # This class wraps the AST block node that represents the entire cask
    # definition. It includes various helper methods to aid cops in their
    # analysis.
    class CaskBlock
      CASK_METHOD_NAMES = [:cask, :test_cask]

      attr_reader :cask_block_node

      def initialize(cask_block_node)
        @cask_block_node = cask_block_node
      end

      def cask?
        CASK_METHOD_NAMES.include?(header.method_name)
      end

      def header
        return @header if defined? @header
        method_node, _block_args, _body = cask_block_node.children
        @header = CaskHeader.new(method_node)
      end
    end

    # This class wraps the AST method node that represents the cask header. It
    # includes various helper methods to aid cops in their analysis.
    class CaskHeader
      attr_reader :method_node

      def initialize(method_node)
        @method_node = method_node
      end

      def dsl_version?
        method_args.any? && method_args.first.type == :hash
      end

      def test_cask?
        method_name == :test_cask || dsl_version.to_s.include?('test')
      end

      def header_str
        @header_str ||= source_range.source
      end

      def source_range
        @source_range ||= method_node.loc.expression
      end

      def preferred_header_str
        "#{preferred_method_name} '#{cask_token}'"
      end

      def preferred_method_name
        test_cask? ? :test_cask : :cask
      end

      def method_name
        return @method_name if defined? @method_name
        extract_method
        @method_name
      end

      def method_args
        return @method_args if defined? @method_args
        extract_method
        @method_args
      end

      def dsl_version
        return @dsl_version if defined? @dsl_version
        extract_hash
        @dsl_version
      end

      def cask_token
        return @cask_token if defined? @cask_token
        extract_hash
        @cask_token
      end

      def hash_node
        @hash_node ||= method_args.first
      end

      private

      def extract_method
        _receiver, @method_name, *@method_args = method_node.children
      end

      def extract_hash
        key_node, value_node = *hash_node.children.first
        @dsl_version = key_node.children.first
        @cask_token = value_node.children.first
      end
    end
  end
end
