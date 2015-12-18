describe RuboCop::Cop::Cask::NoDslVersion do
  subject(:cop) { described_class.new }

  it 'checks for dsl version in cask header' do
    inspect_source(cop, [
      "cask :v1 => 'foo' do",
      'end'
    ])
    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.first.line).to eq(1)
    expect(cop.messages)
      .to eq(["Use `cask 'foo'` instead of `cask :v1 => 'foo'`"])
    expect(cop.highlights)
      .to eq([":v1 => 'foo'"])
  end

  it 'ignores cask header with no dsl version' do
    inspect_source(cop, [
      "cask 'foo' do",
      'end'
    ])
    expect(cop.offenses).to be_empty
  end

  it 'checks for dsl version in test_cask header' do
    inspect_source(cop, [
      "test_cask :v1 => 'foo' do",
      'end'
    ])
    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.first.line).to eq(1)
    expect(cop.messages)
      .to eq(["Use `test_cask 'foo'` instead of `test_cask :v1 => 'foo'`"])
    expect(cop.highlights)
      .to eq([":v1 => 'foo'"])
  end

  it 'ignores test_cask header with no dsl version' do
    inspect_source(cop, [
      "test_cask 'foo' do",
      'end'
    ])
    expect(cop.offenses).to be_empty
  end
end
