require "spec_helper"
require "tempfile"
require_relative "../../lib/ping_response"

RSpec.describe PingResponse do
  let(:valid_version_file_content) {
    { version_number: "1.23", build_date: Time.now, commit_id: "irrelevant sha", build_tag: "irrelevant build tag" }
  }

  let(:unknown_version_response) {
    { version_number: "unknown", build_date: nil, commit_id: "unknown", build_tag: "unknown" }
  }

  let(:overridden_version_file) do
    filehandle = Tempfile.new("ping_response")

    filehandle.write(valid_version_file_content.to_yaml)
    filehandle.close

    filehandle.path
  end

  context "with a valid version file" do
    describe ".ok?" do
      it "should return a true value" do
        stub_const("PingResponse::VERSION_FILE", overridden_version_file)
        expect(subject.ok?).to be true
      end
    end

    describe ".data" do
      it "should return a valid set of data" do
        stub_const("PingResponse::VERSION_FILE", overridden_version_file)

        expect(subject.data).to eq(valid_version_file_content)
      end
    end
  end

  context "without a valid version file" do
    describe ".data" do
      it "returns an unknown_version_response" do
        expect(YAML).to receive(:load_file).and_raise(StandardError)

        expect(subject.data).to eq(unknown_version_response)
      end
    end

    describe ".ok?" do
      it "should return a false value" do
        stub_const("PingResponse::VERSION_FILE", "/non-existent-file")
        expect(subject.ok?).to be false
      end
    end
  end
end
