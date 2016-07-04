require 'forwardable'

module RuboCop
  module Cop
    module Cask
      # This cop checks that a cask's homepage matches the download url,
      # or if it doesn't, checks if a comment in the form
      # `# example.com was verified as official when first introduced to the cask`
      # is present.
      class HomepageMatchesUrl < Cop
        extend Forwardable
        include CaskHelp

        MSG_NO_MATCH = '`%s` does not match `%s`'.freeze

        MSG_MISSING = '`%s` does not match `%s`, a comment in the form of ' \
                      '`# example.com was verified as official when first ' \
                      'introduced to the cask` has to be added above the ' \
                      '`url` stanza'.freeze

        MSG_UNNECESSARY = '`%s` matches `%s`, the comment above the `url` ' \
                          'stanza is unnecessary'.freeze

        def on_cask(cask_block)
          @cask_block = cask_block
          add_offenses
        end

        private

        attr_reader :cask_block
        def_delegators :cask_block, :cask_node, :toplevel_stanzas,
                       :sorted_toplevel_stanzas

        def add_offenses
          toplevel_stanzas.select(&:url?).each do |url|
            if url_match_homepage?(url)
              next unless comment?(url)
              add_offense_unnecessary_comment(url)
            elsif !comment?(url)
              add_offense_missing_comment(url)
            elsif !comment_matches_url?(url)
              add_offense_no_match(url)
            end
          end
        end

        def add_offense_missing_comment(stanza)
          range = stanza.source_range
          add_offense(range, range, format(MSG_MISSING, domain(stanza), homepage))
        end

        def add_offense_unnecessary_comment(stanza)
          comment = comment(stanza).loc.expression
          add_offense(comment,
                      comment,
                      format(MSG_UNNECESSARY, domain(stanza), homepage))
        end

        def add_offense_no_match(stanza)
          comment = comment(stanza).loc.expression
          add_offense(comment,
                      comment,
                      format(MSG_NO_MATCH, url_from_comment(stanza), full_url(stanza)))
        end

        def comment?(stanza)
          !stanza.comments.empty?
        end

        def comment(stanza)
          stanza.comments.last
        end

        def url_from_comment(stanza)
          comment(stanza).text
            .sub(/.*# ([^ ]*) was verified as official when first introduced to the cask$/, '\1')
        end

        def comment_matches_url?(stanza)
          full_url(stanza).include?(url_from_comment(stanza))
        end

        def strip_http(url)
          url.sub(%r{^.*://(www\.)?}, '')
        end

        def domain(stanza)
          strip_http(extract_url(stanza)).gsub(%r{^([^/]+).*}, '\1')
        end

        def extract_url(stanza)
          string = stanza.stanza_node.children[2]
          return string.str_content if string.str_type?
          string.to_s.gsub(%r{.*"([a-z0-9]+\:\/\/[^"]+)".*}m, '\1')
        end

        def url_match_homepage?(stanza)
          domain(stanza).end_with?(homepage)
        end

        def full_url(stanza)
          strip_http(extract_url(stanza))
        end

        def homepage
          domain(toplevel_stanzas.find(&:homepage?))
        end
      end
    end
  end
end
