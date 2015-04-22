require 'spec_helper'

require 'json'

RSpec.shared_examples 'available resource' do |name|
  plural_name = name.pluralize
  path_prefix = name.pluralize
  single_resource_method = single_hash_prefix = name.to_sym
  collection_resource_method = collection_hash_prefix = name.pluralize.to_sym
  model = "Drs::AuthClient::Models::#{name.classify}".constantize

  describe "\##{single_resource_method}" do
    let(:uid) { 'SOME-UID' }
    let(:path) { "#{path_prefix}/#{uid}" }
    let(:response_code) { 200 }
    let(:response_body) { -> (env) {{}.to_json} }

    subject { client.send(single_resource_method, uid) }

    it 'makes the correct request' do
      subject

      stubbed_calls.verify_stubbed_calls
    end

    context "for existing #{name}" do
      let(:response_hash) { Hash[single_hash_prefix, {uid: uid, other: 'OTHER'}] }
      let(:response_body) { -> (env) {response_hash.to_json} }

      it "returns new #{model} object" do
        is_expected.to be_a(model)
      end
      it "the #{name} contains the returned data" do
        expect(subject.uid).to eql(uid)
      end
    end

    context "for non-existing #{name}" do
      let(:response_code) { 404 }
    end
  end

  describe "\##{collection_resource_method}" do
    let(:path) { path_prefix }
    let(:response_code) { 200 }
    let(:response_body) { -> (env) {{}.to_json} }

    subject { client.send(collection_resource_method) }

    it 'makes the correct request' do
      subject

      stubbed_calls.verify_stubbed_calls
    end

    context "when multiple #{plural_name} exist" do
      let(:response_hash) { Hash[collection_hash_prefix, [{uid: 'UID 1', other: 'NAME 1'}, {uid: 'UID 2', other: 'NAME 2'}]] }
      let(:response_body) { -> (env) {response_hash.to_json} }

      it "returns all #{plural_name}" do
        expect(subject.size).to be(2)
      end

      it "all returned object are #{plural_name}" do
        expect(subject.all? {|o| o.is_a?(model)}).to be true
      end

      it 'the collection contains the returned data' do
        expect(subject.map(&:uid)).to match_array(['UID 1', 'UID 2'])
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

  include_examples 'available resource', 'organisation'
  include_examples 'available resource', 'profile'
end