require 'spec_helper'

require 'json'

RSpec.describe Drs::AuthClient::Client do

  let(:host) { 'HOST' }
  let(:version) { :v5 }
  let(:auth_token) { 'OAUTH ACCESS TOKEN' }

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
    let(:response_body) { -> (env) { "successful response with authorization: #{env.request_headers['Authorization']}" } }

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

  describe '#organisation' do
    let(:uid) { 'SOME-UID' }
    let(:path) { "organisations/#{uid}" }
    let(:response_code) { 200 }
    let(:response_body) { -> (env) {{}.to_json} }

    subject { client.organisation(uid) }

    it 'makes the correct request' do
      subject

      stubbed_calls.verify_stubbed_calls
    end

    context 'for existing organisation' do
      let(:response_hash) do
        {
            organisation: {
                uid: uid,
                name: 'NAME'
            }
        }
      end
      let(:response_body) { -> (env) {response_hash.to_json} }

      it 'returns new Organisation object' do
        is_expected.to be_a(Drs::AuthClient::Models::Organisation)
      end
      it 'the organisation contains the returned data' do
        expect(subject.uid).to eql(uid)
      end
    end

    context 'for non-existing organisation' do
      let(:response_code) { 404 }
    end
  end

  describe '#organisations' do
    let(:path) { 'organisations'}
    let(:response_code) { 200 }
    let(:response_body) { -> (env) {{}.to_json} }

    subject { client.organisations }

    it 'makes the correct request' do
      subject

      stubbed_calls.verify_stubbed_calls
    end

    context 'when multiple organisations exist' do
      let(:response_hash) do
        {
            organisations: [
                {
                    uid: 'UID 1',
                    name: 'NAME 1'
                }, {
                    uid: 'UID 2',
                    name: 'NAME 2'
                }
            ]
        }
      end
      let(:response_body) { -> (env) {response_hash.to_json} }

      it 'returns all organisations' do
        expect(subject.size).to be(2)
      end

      it 'all returned object are organisations' do
        expect(subject.all? {|o| o.is_a?(Drs::AuthClient::Models::Organisation)}).to be true
      end

      it 'the collection contains the returned data' do
        expect(subject[0].uid).to eql('UID 1')
        expect(subject[1].uid).to eql('UID 2')
      end

    end

    context 'when no organisations exist' do
      let(:response_hash) { {organisations: []} }
      let(:response_body) { -> (env) {response_hash.to_json} }

      it 'returns empty array' do
        is_expected.to eql([])
      end
    end
  end
end