describe RuboCop::Cop::Cask::StanzaGrouping do
  include CopSharedExamples

  subject(:cop) { described_class.new }
  let(:missing_line_msg) do
    'stanza groups should be separated by a single empty line'
  end
  let(:extra_line_msg) do
    'stanzas within the same group should have no lines between them'
  end

  context 'when no stanzas are incorrectly grouped' do
    let(:source) do
      <<-CASK.undent
        cask 'foo' do
          version :latest
          sha256 :no_check
        end
      CASK
    end

    include_examples 'does not report any offenses'
  end

  context 'when one stanza is incorrectly grouped' do
    let(:source) do
      <<-CASK.undent
        cask 'foo' do
          version :latest

          sha256 :no_check
        end
      CASK
    end
    let(:correct_source) do
      <<-CASK.undent
        cask 'foo' do
          version :latest
          sha256 :no_check
        end
      CASK
    end
    let(:expected_offenses) do
      [
        {
          message: extra_line_msg,
          severity: :convention,
          line: 3,
          column: 0,
          source: "\n"
        }
      ]
    end

    include_examples 'reports offenses'

    include_examples 'autocorrects offenses'
  end

  context 'when many stanzas are incorrectly grouped' do
    let(:source) do
      <<-CASK.undent
        cask 'foo' do
          version :latest
          sha256 :no_check
          url 'https://foo.example.com/foo.zip'

          name 'Foo'

          homepage 'https://foo.example.com'
          license :mit

          app 'Foo.app'
          uninstall :quit => 'com.example.foo',
                    :kext => 'com.example.foo.kextextension'
        end
      CASK
    end
    let(:correct_source) do
      <<-CASK.undent
        cask 'foo' do
          version :latest
          sha256 :no_check

          url 'https://foo.example.com/foo.zip'
          name 'Foo'
          homepage 'https://foo.example.com'
          license :mit

          app 'Foo.app'

          uninstall :quit => 'com.example.foo',
                    :kext => 'com.example.foo.kextextension'
        end
      CASK
    end
    let(:expected_offenses) do
      [
        {
          message: missing_line_msg,
          severity: :convention,
          line: 4,
          column: 0,
          source: "  url 'https://foo.example.com/foo.zip'"
        },
        {
          message: extra_line_msg,
          severity: :convention,
          line: 5,
          column: 0,
          source: "\n"
        },
        {
          message: extra_line_msg,
          severity: :convention,
          line: 7,
          column: 0,
          source: "\n"
        },
        {
          message: missing_line_msg,
          severity: :convention,
          line: 12,
          column: 0,
          source: "  uninstall :quit => 'com.example.foo',"
        }
      ]
    end

    include_examples 'reports offenses'

    include_examples 'autocorrects offenses'
  end

  # TODO: detect incorrectly grouped stanzas in nested expressions
  context 'when stanzas are nested in a conditional expression' do
    let(:source) do
      <<-CASK.undent
        cask 'foo' do
          if true
            version :latest

            sha256 :no_check
          end
        end
      CASK
    end

    include_examples 'does not report any offenses'
  end
end
