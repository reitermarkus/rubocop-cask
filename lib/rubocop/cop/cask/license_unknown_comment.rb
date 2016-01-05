module RuboCop
  module Cop
    module Cask
      # This cop checks that if a cask uses `license :unknown`, it is followed
      # on the same line by the machine-generated TODO comment.
      class LicenseUnknownComment < Cop
        include CaskHelp

        COMMENT_TEXT = '# TODO: change license and remove this comment; ' \
                       "':unknown' is a machine-generated placeholder"
        MISSING_MSG = "Missing required comment: `#{COMMENT_TEXT}`"
        INLINE_MSG = 'Comment belongs on the same line as `license :unknown`'

        def on_cask(cask_block)
          license_stanza = cask_block.stanzas.find(&:license?)
          return unless license_stanza && license_unknown?(license_stanza)
          add_offenses(license_stanza)
        end

        def autocorrect(stanza)
          lambda do |corrector|
            comment = license_unknown_comment
            remove_comment(corrector, comment) if comment
            add_comment(corrector, stanza)
          end
        end

        private

        attr_reader :cask_block

        def license_unknown?(stanza)
          stanza.source.include?(':unknown')
        end

        def add_offenses(stanza)
          comment = license_unknown_comment
          add_missing_offense(stanza) unless comment
          add_not_inline_offense(stanza, comment) if comment &&
              !on_same_line?(stanza, comment)
        end

        def license_unknown_comment
          processed_source.comments.find { |c| c.text == COMMENT_TEXT }
        end

        def add_missing_offense(stanza)
          add_offense(stanza, stanza.source_range, MISSING_MSG)
        end

        def add_not_inline_offense(stanza, comment)
          add_offense(stanza, comment.loc.expression, INLINE_MSG)
        end

        def on_same_line?(stanza, comment)
          stanza.source_range.line == comment.loc.line
        end

        def remove_comment(corrector, comment)
          line = comment.loc.line
          length = processed_source[line - 1].length
          range = source_range(processed_source.buffer, line, 0, length + 1)
          corrector.remove(range)
        end

        def add_comment(corrector, stanza)
          corrector.insert_after(stanza.source_range, " #{COMMENT_TEXT}")
        end
      end
    end
  end
end
