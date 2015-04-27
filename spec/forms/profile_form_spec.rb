require "rails_helper"

RSpec.describe ProfileForm do
  let (:profile) { Profile.new }
  subject { ProfileForm.new(profile) }

  describe "submit" do
    let (:profile_params) { attributes_for :profile,
                                           email: "dave@example.com" }

    context "profile" do
      context "with valid params" do
        it "returns true, and has no errors" do
          expect(subject.submit(profile_params)).to eql true
          expect(subject.errors).to be_blank
        end

        it "saves the Profile and doesn't create a new User" do
          subject.submit(profile_params)
          expect(User.count).to eq 0
          expect(Profile.count).to eq 1
        end
      end

      context "with invalid params" do
        let(:invalid_profile_params) { profile_params.merge({ name: "",
                                                              tel: "",
                                                              mobile: "",
                                                              address: "",
                                                              postcode: "",
                                                              email: "" }) }

        it "returns false, and has errors" do
          expect(subject.submit(invalid_profile_params)).to eql false
          expect(subject.errors.keys).to match_array([:name, :tel, :mobile, :address, :postcode, :email])
        end

        it "does not create a Profile or a User" do
          subject.submit(invalid_profile_params)
          expect(User.count).to eq 0
          expect(Profile.count).to eq 0
        end
      end

      context "with duplicate email address" do
        let!(:existing_profile) { Profile.create(name: "John Jones",
                                                 tel: "01234567890",
                                                 mobile: "01234567890",
                                                 address: "another street",
                                                 postcode: "XX1 1XX",
                                                 email: "dave@example.com") }

        it "returns false, and has errors" do
          expect(subject.submit(profile_params)).to eql false
          expect(subject.errors.keys).to eq [:email]
        end

        it "does not create a Profile or a User" do
          subject.submit(profile_params)
          expect(User.count).to eq 0
          expect(Profile.count).to eq 1
        end
      end
    end

    context "profile and user" do
      let (:profile_and_user_params) { profile_params.merge({ associated_user: "1",
                                                              user_attributes:
                                                                { password: "password",
                                                                  password_confirmation: "password" }
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
          expect(Profile.count).to eq 1
        end
      end

      context "with invalid params" do
        context "with a blank password and confirmation" do
          let(:blank_passwords) { profile_params.merge({ associated_user: "1",
                                                         user_attributes:
                                                           { password: "",
                                                             password_confirmation: "" }
                                                       }) }

          it "returns false, and has errors" do
            expect(subject.submit(blank_passwords)).to eql false
            expect(subject.errors.keys).to match_array([:"user.password"])
          end

          it "does not create a Profile or a User" do
            subject.submit(blank_passwords)
            expect(User.count).to eq 0
            expect(Profile.count).to eq 0
          end
        end

        context "with different password and confirmation" do
          let(:different_passwords) { profile_params.merge({ associated_user: "1",
                                                             user_attributes:
                                                               { password: "password_1",
                                                                 password_confirmation: "password_2" }
                                                           }) }

          it "returns false, and has errors" do
            expect(subject.submit(different_passwords)).to eql false
            expect(subject.errors.keys).to match_array([:"user.password_confirmation"])
          end

          it "does not create a Profile or a User" do
            subject.submit(different_passwords)
            expect(User.count).to eq 0
            expect(Profile.count).to eq 0
          end
        end

        context "with a valid user and an invalid profile" do
          #
          # The user is always inserted into the DB first,
          # before the profile. This test is to ensure that
          # if we have a valid user, but invalid profile,
          # that the rollback occurs correctly.
          #
          let (:profile_and_user_params) { profile_params.merge({ associated_user: "1",
                                                                  user_attributes:
                                                                  { password: "password",
                                                                    password_confirmation: "password" }
                                                                }) }
          it "does not create either model" do
            allow_any_instance_of(User).to receive(:save).and_return(false)

            expect(subject.submit(profile_and_user_params)).to eql false

            expect(User.count).to eq 0
            expect(Profile.count).to eq 0
          end
        end
      end
    end
  end
end
