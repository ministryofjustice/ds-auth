require 'rails_helper'

RSpec.describe ProfileForm do
  let (:profile) { create(:profile) }
  subject { ProfileForm.new(profile) }

  describe "submit" do

    let (:profile_params) { { name: 'Dave Smith',
                              tel: '999999',
                              mobile: '8888888',
                              address: 'a street',
                              postcode: 'XX1 1XX',
                              email: 'dave@example.com'} }

    context "profile" do

      context "with valid params" do

        it "returns true, and has no errors" do
          expect(subject.submit(profile_params)).to eql true
          expect(subject.errors).to be_blank
        end

        it "saves and doesnt creates a new User" do
          subject.submit(profile_params)
          expect(User.count).to eq 0
        end
      end

      context "with invalid params" do

        let(:invalid_profile_params) { profile_params.merge({ name: '',
                                                              tel: '',
                                                              mobile: '',
                                                              address: '',
                                                              postcode: '',
                                                              email: '' }) }

        it "returns false, and has errors" do
          expect(subject.submit(invalid_profile_params)).to eql false
          expect(subject.errors.keys).to match_array([:name, :tel, :mobile, :address, :postcode, :email])
        end
      end

      context "with duplicate email address" do
        let!(:profile2) { Profile.create(name: 'John Jones',
                                         tel: '111111',
                                         mobile: '2222222',
                                         address: 'another street',
                                         postcode: 'XX1 1XX',
                                         email: 'dave@example.com') }

        it "returns false, and has errors" do
          expect(subject.submit(profile_params)).to eql false
          expect(subject.errors.keys).to eq [:email]
        end
      end
    end

    context "profile and user" do
      let (:profile_and_user_params) { profile_params.merge({ associated_user: '1',
                                                              user_attributes:
                                                                { password: 'password',
                                                                  password_confirmation: 'password' }
                                                               }) }

      context "with valid params" do
        it "returns true, and has no errors" do
          expect(subject.submit(profile_and_user_params)).to eql true
          expect(subject.errors).to be_blank
        end

        it "saves and creates a new User" do
          subject.submit(profile_and_user_params)
          expect(User.count).to eq 1
          expect(User.last.email).to eq Profile.last.email
        end
      end

      context "with invalid params" do
        let(:blank_passwords) { profile_params.merge({ associated_user: '1',
                                                       user_attributes:
                                                         { password: '',
                                                           password_confirmation: '' }
                                                     }) }

        let(:different_passwords) { profile_params.merge({ associated_user: '1',
                                                           user_attributes:
                                                             { password: 'password_1',
                                                               password_confirmation: 'password_2' }
                                                         }) }

        it "with blank password and confirmation returns false, and has errors" do
          expect(subject.submit(blank_passwords)).to eql false
          expect(subject.errors.keys).to match_array([:"user.password"])
        end

        it "with different password and confirmation returns false, and has errors" do
          expect(subject.submit(different_passwords)).to eql false
          expect(subject.errors.keys).to match_array([:"user.password_confirmation"])
        end
      end
    end
  end
end
