describe RuboCop::Cop::Cask::NoDslVersion do
  include CopSharedExamples

  subject(:cop) { described_class.new }

  context 'with header method `cask`' do
    let(:header_method) { 'cask' }

    context 'with no dsl version' do
      let(:source) { "cask 'foo' do; end" }

      include_examples 'does not report any offenses'
    end

    context 'with dsl version' do
      let(:source) { "cask :v1 => 'foo' do; end" }
      let(:correct_source) { "cask 'foo' do; end" }
      let(:expected_offenses) do
        [{ message: "Use `cask 'foo'` instead of `cask :v1 => 'foo'`",
           severity: :convention, line: 1, column: 0,
           highlight: "cask :v1 => 'foo'" }]
      end

      include_examples 'reports offenses'

      include_examples 'autocorrects offenses'
    end

    context 'with dsl version containing "test"' do
      let(:source) { "cask :v1test => 'foo' do; end" }
      let(:correct_source) { "test_cask 'foo' do; end" }
      let(:expected_offenses) do
        [{ message: "Use `test_cask 'foo'` instead of `cask :v1test => 'foo'`",
           severity: :convention, line: 1, column: 0,
           highlight: "cask :v1test => 'foo'" }]
      end

      include_examples 'reports offenses'

      include_examples 'autocorrects offenses'
    end
  end

  context 'with header method `test_cask`' do
    context 'with no dsl version' do
      let(:source) { "test_cask 'foo' do; end" }

      include_examples 'does not report any offenses'
    end

    context 'with dsl version' do
      let(:source) { "test_cask :v1 => 'foo' do; end" }
      let(:correct_source) { "test_cask 'foo' do; end" }
      let(:expected_offenses) do
        [{ message: "Use `test_cask 'foo'` instead of `test_cask :v1 => 'foo'`",
           severity: :convention, line: 1, column: 0,
           highlight: "test_cask :v1 => 'foo'" }]
      end

      include_examples 'reports offenses'

      include_examples 'autocorrects offenses'
    end
  end
end
