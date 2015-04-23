require "spec_helper"

RSpec.describe Drs::AuthClient do
  [:host, :version].each do |attr|
    it "allows #{attr} to be set" do
      described_class.respond_to?("#{attr}=")
    end

    it "allows #{attr} to be read" do
      described_class.respond_to?(attr)
    end
  end

  describe ".configure" do
    it "yields with passing itself as an argument" do
      expect { |block| described_class.configure(&block) }.to yield_with_args(described_class)
    end
  end
end
