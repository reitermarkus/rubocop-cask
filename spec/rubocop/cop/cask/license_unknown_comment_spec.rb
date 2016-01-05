describe RuboCop::Cop::Cask::LicenseUnknownComment do
  include CopSharedExamples

  subject(:cop) { described_class.new }
  let(:license_unknown_comment) { described_class.const_get(:COMMENT_TEXT) }

  context 'when cask has no license stanza' do
    let(:source) { "cask 'foo' do; end" }

    include_examples 'does not report any offenses'
  end

  context 'when license is not :unknown' do
    let(:source) do
      <<-CASK.undent
        cask 'foo' do
          license :mit
        end
      CASK
    end

    include_examples 'does not report any offenses'
  end

  context 'when license is :unknown' do
    let(:correct_source) do
      <<-CASK.undent
        cask 'foo' do
          license :unknown #{license_unknown_comment}
        end
      CASK
    end

    context 'with required comment on same line' do
      let(:source) { correct_source }

      include_examples 'does not report any offenses'
    end

    context 'with required comment on preceding line' do
      let(:source) do
        <<-CASK.undent
          cask 'foo' do
            #{license_unknown_comment}
            license :unknown
          end
        CASK
      end
      let(:expected_offenses) do
        [{
          message: 'Comment belongs on the same line as `license :unknown`',
          severity: :convention,
          line: 2,
          column: 2,
          source: "#{license_unknown_comment}"
        }]
      end

      include_examples 'reports offenses'

      include_examples 'autocorrects source'
    end

    context 'with required comment missing' do
      let(:source) do
        <<-CASK.undent
          cask 'foo' do
            license :unknown
          end
        CASK
      end
      let(:expected_offenses) do
        [{
          message: "Missing required comment: `#{license_unknown_comment}`",
          severity: :convention,
          line: 2,
          column: 2,
          source: 'license :unknown'
        }]
      end

      include_examples 'reports offenses'

      include_examples 'autocorrects source'
    end
  end
end
