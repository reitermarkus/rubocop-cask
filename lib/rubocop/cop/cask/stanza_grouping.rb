require 'forwardable'
require 'pry'

module RuboCop
  module Cop
    module Cask
      # This cop checks that a cask's stanzas are grouped correctly.
      # See https://github.com/caskroom/homebrew-cask/blob/master/CONTRIBUTING.md#stanza-order
      # for more info.
      class StanzaGrouping < Cop
        extend Forwardable
        include CaskHelp

        MISSING_LINE_MSG = 'stanza groups should be separated by a single ' \
                           'empty line'

        EXTRA_LINE_MSG = 'stanzas within the same group should have no lines ' \
                         'between them'

        def on_cask(cask_node)
          @cask_block = RuboCop::Cask::AST::CaskBlock.new(cask_node)
          @line_ops = {}
          add_offenses
        end

        def autocorrect(range)
          lambda do |corrector|
            case line_ops[range.line - 1]
            when :insert
              corrector.insert_before(range, "\n")
            when :remove
              corrector.remove(range)
            end
          end
        end

        private

        attr_reader :cask_block, :line_ops
        def_delegators :cask_block, :cask_node, :toplevel_stanzas

        def add_offenses
          toplevel_stanzas.each_cons(2) do |stanza, next_stanza|
            next unless next_stanza
            if missing_line_after?(stanza, next_stanza)
              add_offense_missing_line(stanza)
            elsif extra_line_after?(stanza, next_stanza)
              add_offense_extra_line(stanza)
            end
          end
        end

        def missing_line_after?(stanza, next_stanza)
          !(stanza.same_group?(next_stanza) ||
            empty_line_after?(stanza))
        end

        def extra_line_after?(stanza, next_stanza)
          stanza.same_group?(next_stanza) &&
            empty_line_after?(stanza)
        end

        def empty_line_after?(stanza)
          source_line_after(stanza).empty?
        end

        def source_line_after(stanza)
          processed_source[index_of_line_after(stanza)]
        end

        def index_of_line_after(stanza)
          stanza.expression.last_line
        end

        def add_offense_missing_line(stanza)
          line_index = index_of_line_after(stanza)
          line_ops[line_index] = :insert
          add_offense(line_index, MISSING_LINE_MSG)
        end

        def add_offense_extra_line(stanza)
          line_index = index_of_line_after(stanza)
          line_ops[line_index] = :remove
          add_offense(line_index, EXTRA_LINE_MSG)
        end

        def add_offense(line_index, msg)
          line_length = [processed_source[line_index].size, 1].max
          range = source_range(processed_source.buffer, line_index + 1, 0,
                               line_length)
          super(range, range, msg)
        end
      end
    end
  end
end
