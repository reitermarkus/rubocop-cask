describe RuboCop::Cask do
  describe 'the default configuration file' do
    subject(:default_config) {
      RuboCop::ConfigLoader.load_file('config/default.yml')
    }

    let(:cop_names) {
      cop_files = Dir.glob(File.join(__dir__, '..', '..', 'lib',
                                     'rubocop', 'cop', 'cask', '*.rb'))
      cop_files.map { |file|
        cop_name = File.basename(file, '.rb')
          .gsub(/(^|_)(.)/) { Regexp.last_match(2).upcase }

        "Cask/#{cop_name}"
      }
    }

    let(:cask_config_keys) {
      default_config.keys.select { |k| k.start_with?('Cask/') }
    }

    it 'includes all cops' do
      expect(cask_config_keys.sort).to eq(cop_names.sort)
    end

    matcher :have_a_description do
      match do |cop_name|
        expect(default_config[cop_name]['Description']).not_to be nil
        expect(default_config[cop_name]['Description']).not_to include("\n")
      end
    end

    it 'has a nicely formatted description for all cops' do
      expect(cop_names).to all have_a_description
    end
  end
end
