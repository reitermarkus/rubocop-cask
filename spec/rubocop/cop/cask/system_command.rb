describe RuboCop::Cop::Cask::SystemCommand do
  include CopSharedExamples

  subject(:cop) { described_class.new }

  context 'when system_command is used' do
    context 'inside a *flight block' do
      let(:source) do
        <<-CASK.undent
          cask 'foo' do
            preflight do
              system_command 'ls'
            end
          end
        CASK
      end

      include_examples 'does not report any offenses'
    end

    context 'outside a *flight block' do
      let(:source) do
        <<-CASK.undent
          cask 'foo' do
            system_command 'ls'
          end
        CASK
      end

      include_examples 'does not report any offenses'
    end
  end

  context 'when system is used' do
    context 'inside a *flight block' do
      let(:source) do
        <<-CASK.undent
          cask 'foo' do
            preflight do
              system 'ls'
            end
          end
        CASK
      end

      include_examples 'reports offenses'
    end

    context 'outside a *flight block' do
      let(:source) do
        <<-CASK.undent
          cask 'foo' do
            system 'ls'
          end
        CASK
      end

      include_examples 'reports offenses'
    end
  end
end
