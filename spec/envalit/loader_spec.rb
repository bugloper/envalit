# frozen_string_literal: true

require "spec_helper"

RSpec.describe Envalit::Loader do
  let(:loader) { described_class.new }
  let(:env_file) { ".env" }
  let(:env_example_file) { ".env.example" }

  # Helper method to strip ANSI color codes from strings
  def strip_color_codes(string)
    string.gsub(/\e\[\d+(?:;\d+)*m/, "")
  end

  before do
    # Clear any existing environment variables
    ENV.clear
  end

  after do
    # Clean up test files
    FileUtils.rm_f(env_file)
    FileUtils.rm_f(env_example_file)
  end

  describe "#register" do
    it "registers a required string variable" do
      loader.register("API_KEY", type: :string, required: true)
      expect(loader.instance_variable_get(:@schema)).to include(
        "API_KEY" => { type: :string, required: true }
      )
    end

    it "registers an optional integer variable" do
      loader.register("PORT", type: :integer, required: false)
      expect(loader.instance_variable_get(:@schema)).to include(
        "PORT" => { type: :integer, required: false }
      )
    end

    it "raises an error for invalid type" do
      expect do
        loader.register("INVALID", type: :invalid)
      end.to raise_error(ArgumentError) do |error|
        expect(strip_color_codes(error.message)).to eq(
          "Invalid type: invalid. Valid types are: string, integer, boolean, float"
        )
      end
    end
  end

  describe "#validate" do
    before do
      loader.register("API_KEY", type: :string, required: true)
      loader.register("PORT", type: :integer, required: false)
    end

    context "when required variables are missing" do
      it "raises ValidationError" do
        expect do
          loader.validate!
        end.to raise_error(Envalit::ValidationError) do |error|
          expect(strip_color_codes(error.message)).to match(/Missing required environment variables:\n  - API_KEY/)
        end
      end

      it "suggests copying from .env.example when it exists" do
        File.write(env_example_file, "API_KEY=test_key\nPORT=3000")
        expect do
          loader.validate!
        end.to raise_error(Envalit::ValidationError) do |error|
          message = strip_color_codes(error.message)
          expect(message).to match(/Missing required environment variables:/)
          expect(message).to match(/  - API_KEY/)
          expect(message).to match(/2\. Copy values from \.env\.example to your \.env file:/)
          expect(message).to match(/cp \.env\.example \.env/)
        end
      end
    end

    context "when variables are present but have invalid types" do
      before do
        ENV["API_KEY"] = "test_key"
        ENV["PORT"] = "not_a_number"
      end

      it "raises ValidationError for invalid type" do
        expect do
          loader.validate!
        end.to raise_error(Envalit::ValidationError) do |error|
          expect(strip_color_codes(error.message)).to match(/Invalid type for PORT: expected integer/)
        end
      end
    end

    context "when all variables are valid" do
      before do
        ENV["API_KEY"] = "test_key"
        ENV["PORT"] = "3000"
      end

      it "does not raise an error" do
        expect { loader.validate! }.not_to raise_error
      end
    end
  end

  describe "#load" do
    before do
      loader.register("API_KEY", type: :string, required: true)
      loader.register("PORT", type: :integer, required: false)
    end

    context "when .env file exists" do
      before do
        File.write(env_file, "API_KEY=test_key\nPORT=3000")
      end

      it "loads variables from .env file" do
        loader.load
        expect(ENV.fetch("API_KEY", nil)).to eq("test_key")
        expect(ENV.fetch("PORT", nil)).to eq("3000")
      end
    end

    context "when .env file does not exist" do
      it "does not raise an error" do
        expect { loader.load }.not_to raise_error
      end
    end
  end
end
