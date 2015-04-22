require 'spec_helper'

RSpec.describe Drs::AuthClient::Models::Base do
  class SampleModel < Drs::AuthClient::Models::Base
    attr_accessor :title, :age
  end

  let(:attributes) { {title: 'SOME TITLE', non_existent: 'NON EXISTENT'} }
  subject(:model) { SampleModel.new(attributes) }

  describe '#initialize' do
    it 'creates a new model' do
      is_expected.to be_a(SampleModel)
    end

    it 'assigns valid attributes to the new model' do
      expect(subject.title).to eql(attributes[:title])
    end
  end

  describe '.from_hash' do
    subject { SampleModel.from_hash(hash) }

    context 'when the data is correctly prefixed based on the model name' do
      let(:hash) { {sample_model: attributes} }

      it { is_expected.to be_a(described_class) }

      it 'assigns the valid attributes to the returned organisation' do
        expect(subject.title).to eql(attributes[:title])
      end
    end
    context 'for an incorrect data prefix' do
      let(:hash) { {wrong_prefix: attributes} }

      it { is_expected.to be nil }
    end
  end

  describe '.collection_from_hash' do
    subject { SampleModel.collection_from_hash(hash) }

    context 'when the data is correctly prefixed based on the model name' do
      let(:other_attributes) { {title: 'OTHER UID'}}
      let(:hash) { {sample_models: [attributes, other_attributes]} }

      it { is_expected.to be_a(Array) }

      it 'has all the models' do
        expect(subject.size).to be 2
      end

      it 'all models have their attributes assigned' do
        expect(subject[0].title).to eql(attributes[:title])
        expect(subject[1].title).to eql(other_attributes[:title])
      end
    end

    context 'for an incorrect data prefix' do
      let(:hash) { { wrong_prefix: [attributes]}}

      it { is_expected.to be_a(Array)}

      it { is_expected.to be_empty }
    end
  end

end