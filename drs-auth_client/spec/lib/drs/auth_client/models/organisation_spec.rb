require 'spec_helper'

RSpec.describe Drs::AuthClient::Models::Organisation do

  let(:attributes) { {uid: 'UID', non_existent: 'NON EXISTENT'} }
  subject(:organisation) { described_class.new(attributes) }

  describe '#initialize' do

    it 'creates a new organisation' do
      is_expected.to be_a(described_class)
    end

    it 'assigns valid attributes to the new organisation' do
      expect(subject.uid).to eql(attributes[:uid])
    end
  end

  describe '.from_hash' do
    subject { described_class.from_hash(hash) }

    context 'when the data is correctly prefixed based on the model name' do
      let(:hash) { {organisation: attributes} }

      it { is_expected.to be_a(described_class) }

      it 'assigns the valid attributes to the returned organisation' do
        expect(subject.uid).to eql(attributes[:uid])
      end
    end
    context 'for an incorrect data prefix' do
      let(:hash) { {wrong_prefix: attributes} }

      it { is_expected.to be nil }
    end
  end

  describe '.collection_from_hash' do
    subject { described_class.collection_from_hash(hash) }

    context 'when the data is correctly prefixed based on the model name' do
      let(:other_attributes) { {uid: 'OTHER UID'}}
      let(:hash) { {organisations: [attributes, other_attributes]} }

      it { is_expected.to be_a(Array) }

      it 'has all the organisations' do
        expect(subject.size).to be 2
      end

      it 'all organisations have their attributes assigned' do
        expect(subject[0].uid).to eql(attributes[:uid])
        expect(subject[1].uid).to eql(other_attributes[:uid])
      end
    end

    context 'for an incorrect data prefix' do
      let(:hash) { { wrong_prefix: [attributes]}}

      it { is_expected.to be_a(Array)}

      it { is_expected.to be_empty }
    end
  end
end