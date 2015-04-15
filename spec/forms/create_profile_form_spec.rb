require 'rails_helper'

RSpec.describe CreateProfileForm do
  subject { CreateProfileForm }

  describe "save" do

    let (:profile_params) { { name: 'Dave Smith',
                              tel: '999999',
                              mobile: '8888888',
                              address: 'a street',
                              postcode: 'XX1 1XX',
                              email: 'dave@example.com'} }

    context "profile" do

      context "with valid params" do

        it "returns true, and has no errors" do
          form = subject.new(profile_params)
          expect(form.save).to eql true
          expect(form.errors).to be_blank
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
          form = subject.new(invalid_profile_params)
          expect(form.save).to eql false
          expect(form.errors.keys).to eq [:name, :tel, :mobile, :address, :postcode, :email]
          expect(form).to be_invalid
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
          form = subject.new(profile_params)
          expect(form.save).to eql false
          expect(form.errors.keys).to eq [:email]
          expect(form).to be_invalid
        end
      end
    end

    context "profile and user" do
      let (:profile_and_user_params) { profile_params.merge({ associated_user: '1',
                                                              password: 'password',
                                                              password_confirmation: 'password' }) }

      context "with valid params" do
        it "returns true, and has no errors" do
          form = subject.new(profile_and_user_params)
          expect(form.save).to eql true
          expect(form.errors).to be_blank
        end

        it "saves creates a new User" do
          subject.new(profile_and_user_params).save
          expect(User.count).to eq 1
          expect(User.last.email).to eq Profile.last.email
        end
      end

      context "with invalid params" do

        let(:blank_passwords) { profile_and_user_params.merge({ password: '',
                                                                password_confirmation: '' }) }

        let(:different_passwords) { profile_and_user_params.merge({ password: 'onepassword',
                                                                    password_confirmation: 'twopassword' }) }

        it "with blank password and confirmation returns false, and has errors" do
          form = subject.new(blank_passwords)
          expect(form.save).to eql false
          expect(form.errors.keys).to eq [:password, :password_confirmation]
          expect(form).to be_invalid
        end

        it "with different password and confirmation returns false, and has errors" do
          form = subject.new(different_passwords)
          expect(form.save).to eql false
          expect(form.errors.keys).to eq [:password]
          expect(form).to be_invalid
        end
      end
    end
  end
end
