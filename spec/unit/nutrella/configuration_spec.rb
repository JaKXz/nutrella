module Nutrella
  RSpec.describe Configuration do
    let(:path) { "path" }

    it "succeeds when the configuration exists and is well formed" do
      configuration_file_contents(key: "c1", secret: "5f", token: "3c", organization: "org")

      expect(Configuration.values(path)).to eq(key: "c1", secret: "5f", token: "3c", organization: "org")
    end

    it "handles the case when the configuration is missing" do
      configuration_file_missing

      expect(File).to receive(:write).with(path, Configuration::INITIAL_CONFIGURATION)

      expect { Configuration.values(path) }.to output(/you don't have a config file/)
        .to_stderr.and(raise_error(SystemExit))
    end

    it "fails when configuration is malformed (missing secret)" do
      configuration_file_contents(key: "c1", token: "5f", organization: "org")

      expect { Configuration.values(path) }.to output(/#{path} key not found: "secret"/)
        .to_stderr.and(raise_error(SystemExit))
    end

    def configuration_file_contents(values)
      allow(File).to receive(:exist?).with(path).and_return(true)
      allow(YAML).to receive(:load_file).with(path).and_return(values.stringify_keys)
    end

    def configuration_file_missing
      allow(File).to receive(:exist?).with(path).and_return(false)
    end
  end
end
