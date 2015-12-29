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
        MESSAGE = 'Use `%s` instead of `%s`'

        def on_block(block_node)
          @cask_block = RuboCop::Cask::CaskBlock.new(block_node)
          return unless offense?
          offense
        end

        def autocorrect(block_node)
          @cask_block = RuboCop::Cask::CaskBlock.new(block_node)
          lambda do |corrector|
            corrector.replace(header_range, preferred_header_str)
          end
        end

        private

        def offense?
          @cask_block.cask? && @cask_block.header.dsl_version?
        end

        def offense
          add_offense(cask_node, header_range, error_msg)
        end

        def cask_node
          @cask_block.cask_block_node
        end

        def header_range
          @cask_block.header.source_range
        end

        def error_msg
          format(MESSAGE, preferred_header_str, header_str)
        end

        def preferred_header_str
          @cask_block.header.preferred_header_str
        end

        def header_str
          @cask_block.header.header_str
        end
      end
    end
  end
end
