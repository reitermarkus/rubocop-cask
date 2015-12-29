describe RuboCop::Cop::Cask::NoDslVersion do
  subject(:cop) { described_class.new }

  it 'allows cask header with no dsl version' do
    inspect_source(cop, [
      "cask 'foo' do",
      'end'
    ])
    expect(cop.offenses).to be_empty
  end

  it 'detects dsl version in cask header' do
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

  it 'autocorrects dsl version in cask header' do
    new_source = autocorrect_source(cop, [
      "cask :v1 => 'foo' do",
      'end'
    ])
    expect(new_source).to eq([
      "cask 'foo' do",
      'end'
    ].join("\n"))
  end

  it 'detects dsl version with test in cask header' do
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

  it 'autocorrects dsl version with test in cask header' do
    new_source = autocorrect_source(cop, [
      "cask :v1test => 'foo' do",
      'end'
    ])
    expect(new_source).to eq([
      "test_cask 'foo' do",
      'end'
    ].join("\n"))
  end

  it 'allows test_cask header with no dsl version' do
    inspect_source(cop, [
      "test_cask 'foo' do",
      'end'
    ])
    expect(cop.offenses).to be_empty
  end

  it 'detects dsl version in test_cask header' do
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

  it 'autocorrects dsl version in test_cask header' do
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
