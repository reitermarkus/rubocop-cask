describe 'RuboCop Project' do
  describe 'default configuration file' do
    let(:cop_names) do
      cop_files = Dir.glob(File.join(File.dirname(__FILE__), '..', 'lib',
                                     'rubocop', 'cop', 'cask', '*.rb'))
      cop_files.map do |file|
        cop_name = File.basename(file, '.rb')
          .gsub(/(^|_)(.)/) { Regexp.last_match(2).upcase }

        "Cask/#{cop_name}"
      end
    end

    subject(:default_config) do
      RuboCop::ConfigLoader.load_file('config/default.yml')
    end

    it 'has configuration for all cops' do
      expect(default_config.keys.sort).to eq((cop_names).sort)
    end

    it 'has a nicely formatted description for all cops' do
      cop_names.each do |name|
        description = default_config[name]['Description']
        expect(description).not_to be_nil
        expect(description).not_to include("\n")
      end
    end
  end
end
