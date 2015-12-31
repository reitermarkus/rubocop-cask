module CopSharedExamples
  shared_examples 'does not report any offenses' do
    it 'does not report any offenses' do
      inspect_source(cop, source)
      expect(cop.offenses).to be_empty
    end
  end

  shared_examples 'reports offenses' do
    it 'reports offenses' do
      inspect_source(cop, source)
      expect(cop.offenses.size).to eq(expected_offenses.size)
      expected_offenses.zip(cop.offenses).each do |expected, actual|
        expect_offense(expected, actual)
      end
    end
  end

  shared_examples 'autocorrects offenses' do
    it 'autocorrects offenses' do
      new_source = autocorrect_source(cop, source)
      expect(new_source).to eq(Array(correct_source).join("\n"))
    end
  end

  def expect_offense(expected, actual)
    expect(actual.message).to eq(expected[:message])
    expect(actual.severity).to eq(expected[:severity])
    expect(actual.line).to eq(expected[:line])
    expect(actual.column).to eq(expected[:column])
    expect(actual.location.source).to eq(expected[:source])
  end
end
