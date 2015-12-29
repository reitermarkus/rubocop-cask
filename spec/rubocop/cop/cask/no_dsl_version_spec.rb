describe RuboCop::Cop::Cask::NoDslVersion do
  subject(:cop) { described_class.new }

  context 'with header method `cask`' do
    context 'with no dsl version' do
      it 'passes' do
        inspect_source(cop, [
          "cask 'foo' do",
          'end'
        ])
        expect(cop.offenses).to be_empty
      end
    end

    context 'with dsl version' do
      it 'fails' do
        inspect_source(cop, [
          "cask :v1 => 'foo' do",
          'end'
        ])
        expect(cop.offenses.size).to eq(1)
        expect(cop.offenses.first.line).to eq(1)
        expect(cop.messages)
          .to eq(["Use `cask 'foo'` instead of `cask :v1 => 'foo'`"])
        expect(cop.highlights)
          .to eq(["cask :v1 => 'foo'"])
      end

      it 'autocorrects' do
        new_source = autocorrect_source(cop, [
          "cask :v1 => 'foo' do",
          'end'
        ])
        expect(new_source).to eq([
          "cask 'foo' do",
          'end'
        ].join("\n"))
      end
    end

    context 'with dsl version containing "test"' do
      it 'fails' do
        inspect_source(cop, [
          "cask :v1test => 'foo' do",
          'end'
        ])
        expect(cop.offenses.size).to eq(1)
        expect(cop.offenses.first.line).to eq(1)
        expect(cop.messages)
          .to eq(["Use `test_cask 'foo'` instead of `cask :v1test => 'foo'`"])
        expect(cop.highlights)
          .to eq(["cask :v1test => 'foo'"])
      end

      it 'autocorrects' do
        new_source = autocorrect_source(cop, [
          "cask :v1test => 'foo' do",
          'end'
        ])
        expect(new_source).to eq([
          "test_cask 'foo' do",
          'end'
        ].join("\n"))
      end
    end
  end

  context 'with header method `test_cask`' do
    context 'with no dsl version' do
      it 'passes' do
        inspect_source(cop, [
          "test_cask 'foo' do",
          'end'
        ])
        expect(cop.offenses).to be_empty
      end
    end

    context 'with dsl version' do
      it 'fails' do
        inspect_source(cop, [
          "test_cask :v1 => 'foo' do",
          'end'
        ])
        expect(cop.offenses.size).to eq(1)
        expect(cop.offenses.first.line).to eq(1)
        expect(cop.messages)
          .to eq(["Use `test_cask 'foo'` instead of `test_cask :v1 => 'foo'`"])
        expect(cop.highlights)
          .to eq(["test_cask :v1 => 'foo'"])
      end

      it 'autocorrects' do
        new_source = autocorrect_source(cop, [
          "test_cask :v1 => 'foo' do",
          'end'
        ])
        expect(new_source).to eq([
          "test_cask 'foo' do",
          'end'
        ].join("\n"))
      end
    end
  end
end
