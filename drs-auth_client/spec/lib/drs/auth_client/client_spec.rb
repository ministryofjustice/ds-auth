require 'spec_helper'

RSpec.describe Drs::AuthClient::Client do

  let(:host) { 'HOST' }
  let(:version) { :v5 }
  let(:auth_token) { 'OAUTH ACCESS TOKEN'}

  let(:stubbed_calls) do
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get(path) do |env|
        [response_code, {}, response_body.call(env)]
      end
    end
  end

  let(:stubbed_connection) do
    Faraday.new do |builder|
      builder.adapter :test, stubbed_calls
    end
  end

  before do
    Drs::AuthClient.host = host
    Drs::AuthClient.version = version

    allow(Faraday).to receive(:new).and_return(stubbed_connection)
  end

  subject(:client) { described_class.new(auth_token) }

  describe '#get' do
    let(:path) { 'resources/ID' }
    let(:response_code) { 200 }
    let(:response_body) { -> (env) {"successful response with authorization: #{env.request_headers['Authorization']}"} }

    subject { client.get(path) }

    before { subject }

    it 'makes a GET request based on the client configuration' do
      expect(Faraday).to have_received(:new).with("#{host}/api/#{version}")
    end

    it 'makes the GET request for the given resource' do
      stubbed_calls.verify_stubbed_calls
    end

    it 'uses the given auth_token to authorise' do
      is_expected.to match(/#{auth_token}/)
    end

    context 'when the request is 200 successful' do
      it 'returns the body' do
        is_expected.to match(/^successful response/)
      end
    end

    context 'when the request is invalid' do
      let(:response_code) { 400 }

      it { is_expected.to be nil }
    end
  end
end