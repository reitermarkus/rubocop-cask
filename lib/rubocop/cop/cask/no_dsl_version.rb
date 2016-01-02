require 'forwardable'

module RuboCop
  module Cop
    module Cask
      # Do not use the deprecated DSL version syntax in your cask header.
      #
      # @example
      #   # bad
      #   cask :v1 => 'foo' do
      #     ...
      #   end
      #
      #   # good
      #   cask 'foo' do
      #     ...
      #   end
      class NoDslVersion < Cop
        extend Forwardable
        include RuboCop::Cask::CaskHelp

        MESSAGE = 'Use `%s` instead of `%s`'

        def on_cask(cask_node)
          @cask_header = cask_header(cask_node.method_node)
          return unless offense?
          offense
        end

        def autocorrect(method_node)
          @cask_header = cask_header(method_node)
          lambda do |corrector|
            corrector.replace(header_range, preferred_header_str)
          end
        end

        private

        def_delegator :@cask_header, :source_range, :header_range
        def_delegators :@cask_header, :header_str, :preferred_header_str

        def cask_header(method_node)
          RuboCop::Cask::AST::CaskHeader.new(method_node)
        end

        def offense?
          @cask_header.dsl_version?
        end

        def offense
          add_offense(@cask_header.method_node, header_range, error_msg)
        end

        def error_msg
          format(MESSAGE, preferred_header_str, header_str)
        end
      end
    end
  end
end
