describe RuboCop::Cop::Cask::StanzaOrder do
  include CopSharedExamples

  subject(:cop) { described_class.new }

  context 'when no stanzas are out of order' do
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

  context 'when one pair of stanzas is out of order' do
    let(:source) do
      <<-CASK.undent
        cask 'foo' do
          sha256 :no_check
          version :latest
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
          message: '`sha256` stanza out of order',
          severity: :convention,
          line: 2,
          column: 2,
          source: 'sha256 :no_check'
        },
        {
          message: '`version` stanza out of order',
          severity: :convention,
          line: 3,
          column: 2,
          source: 'version :latest'
        }
      ]
    end

    include_examples 'reports offenses'

    include_examples 'autocorrects offenses'
  end

  context 'when many stanzas are out of order' do
    let(:source) do
      <<-CASK.undent
        cask 'foo' do
          url 'https://foo.example.com/foo.zip'
          uninstall :quit => 'com.example.foo',
                    :kext => 'com.example.foo.kext'
          version :latest
          app 'Foo.app'
          sha256 :no_check
        end
      CASK
    end
    let(:correct_source) do
      <<-CASK.undent
        cask 'foo' do
          version :latest
          sha256 :no_check
          url 'https://foo.example.com/foo.zip'
          app 'Foo.app'
          uninstall :quit => 'com.example.foo',
                    :kext => 'com.example.foo.kext'
        end
      CASK
    end
    let(:expected_offenses) do
      [
        {
          message: '`url` stanza out of order',
          severity: :convention,
          line: 2,
          column: 2,
          source: "url 'https://foo.example.com/foo.zip'"
        },
        {
          message: '`uninstall` stanza out of order',
          severity: :convention,
          line: 3,
          column: 2,
          source: "uninstall :quit => 'com.example.foo',\n" \
                "            :kext => 'com.example.foo.kext'"
        },
        {
          message: '`version` stanza out of order',
          severity: :convention,
          line: 5,
          column: 2,
          source: 'version :latest'
        },
        {
          message: '`sha256` stanza out of order',
          severity: :convention,
          line: 7,
          column: 2,
          source: 'sha256 :no_check'
        }
      ]
    end

    include_examples 'reports offenses'

    include_examples 'autocorrects offenses'
  end

  context 'when a stanza appears multiple times' do
    let(:source) do
      <<-CASK.undent
        cask 'foo' do
          name 'Foo'
          url 'https://foo.example.com/foo.zip'
          name 'FancyFoo'
          version :latest
          app 'Foo.app'
          sha256 :no_check
          name 'FunkyFoo'
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
          name 'FancyFoo'
          name 'FunkyFoo'
          app 'Foo.app'
        end
      CASK
    end

    it 'preserves the original order' do
      new_source = autocorrect_source(cop, source)
      expect(new_source).to eq(Array(correct_source).join("\n"))
    end
  end

  # TODO: detect out-of-order stanzas in nested expressions
  context 'when stanzas are nested in a conditional expression' do
    let(:source) do
      <<-CASK.undent
        cask 'foo' do
          if true
            sha256 :no_check
            version :latest
          end
        end
      CASK
    end

    include_examples 'does not report any offenses'
  end
end
