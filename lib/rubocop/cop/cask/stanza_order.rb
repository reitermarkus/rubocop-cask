require 'forwardable'

module RuboCop
  module Cop
    module Cask
      # This cop checks that a cask's stanzas are ordered correctly.
      # See https://github.com/caskroom/homebrew-cask/blob/master/CONTRIBUTING.md#stanza-order
      # for more info.
      class StanzaOrder < Cop
        extend Forwardable
        include CaskHelp

        MESSAGE = '`%s` stanza out of order'

        def on_cask(cask_block)
          @cask_block = cask_block
          add_offenses
        end

        def autocorrect(stanza)
          lambda do |corrector|
            correct_stanza_index = toplevel_stanzas.index(stanza)
            correct_stanza = sorted_toplevel_stanzas[correct_stanza_index]
            corrector.replace(stanza.source_range_with_comments,
                              correct_stanza.source_with_comments)
          end
        end

        private

        attr_reader :cask_block
        def_delegators :cask_block, :cask_node, :toplevel_stanzas,
                       :sorted_toplevel_stanzas

        def add_offenses
          offending_stanzas.each do |stanza|
            message = format(MESSAGE, stanza.stanza_name)
            add_offense(stanza, stanza.source_range_with_comments, message)
          end
        end

        def offending_stanzas
          offending = []
          toplevel_stanzas.each_with_index do |stanza, i|
            offending << stanza unless stanza == sorted_toplevel_stanzas[i]
          end
          offending
        end
      end
    end
  end
end
