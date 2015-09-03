require "rails_helper"

RSpec.describe MembershipsController, type: :controller do

  shared_context "Organisation admin giving a user access to applications" do
    let!(:current_user) { create :user }
    let!(:user) { create :user }
    let!(:application1) { create :doorkeeper_application, available_roles: ["wookie_wrangler"] }
    let!(:application2) { create :doorkeeper_application, available_roles: ["butterfly"] }
    let!(:organisation) { create :organisation }

    before do
      application1.organisations << organisation
      application1.save!

      organisation.memberships.create user: current_user, is_organisation_admin: true

      sign_in current_user
    end
  end

  describe "creating a Membership with application ids that the Organisation does not have access to" do
    include_context "Organisation admin giving a user access to applications"

    def do_post
      post :create, {
        organisation_id: organisation.id,
        membership: {
          user_id: user.id,
          application_memberships_attributes: {
            "0" => {
              application_id: application1.id,
              roles: ["wookie_wrangler"]
            },
            "1" => {
              application_id: application2.id,
              roles: ["butterfly"]
            }
          }
        }
      }
    end

    it "renders the new template" do
      do_post
      expect(subject).to render_template(:new)
    end

    it "does not create any Membership records" do
      expect { do_post }.not_to change(Membership, :count)
    end

    it "does not create any ApplicationMembership records" do
      expect { do_post }.not_to change(ApplicationMembership, :count)
    end

    it "generates errors on the membership object" do
      do_post
      expect(assigns(:membership).errors).not_to be_empty
    end

    it "removes the unaccessible applications from @membership.application_memberships" do
      do_post
      expect(assigns(:membership).application_memberships.size).to eq(1)
      expect(assigns(:membership).application_memberships.first.application_id).to eq(application1.id)
    end
  end

  describe "updating a Membership with application ids that the Organisation does not have access to" do
    include_context "Organisation admin giving a user access to applications"

    let!(:membership) { create :membership, organisation: organisation, user: user }

    def do_patch
      patch :update, {
        organisation_id: organisation.id,
        id: membership.id,
        membership: {
          application_memberships_attributes: {
            "0" => {
              application_id: application1.id,
              roles: ["wookie_wrangler"]
            },
            "1" => {
              application_id: application2.id,
              roles: ["butterfly"]
            }
          }
        }
      }
    end

    it "renders the edit template" do
      do_patch
      expect(subject).to render_template(:edit)
    end

    it "does not create any Membership records" do
      expect { do_patch }.not_to change(Membership, :count)
    end

    it "does not create any ApplicationMembership records" do
      expect { do_patch }.not_to change(ApplicationMembership, :count)
    end

    it "generates errors on the membership object" do
      do_patch
      expect(assigns(:membership).errors).not_to be_empty
    end

    it "removes the unaccessible applications from @membership.application_memberships" do
      do_patch
      expect(assigns(:membership).application_memberships.size).to eq(1)
      expect(assigns(:membership).application_memberships.first.application_id).to eq(application1.id)
    end

    context "when the can_only_grant_own_roles feature is enabled" do
      let(:current_user_membership){ current_user.memberships.last }
      before do
        allow(FeatureFlags::Features).to receive(:enabled?).with("can_only_grant_own_roles").and_return(true)
        create(:application_membership, membership: current_user_membership, application: application1, roles: ["wookie_wrangler"])
        create(:application_membership, membership: current_user_membership, application: application1, roles: ["cheese_monger"])
      end

      it "removes any roles that the current_user does not have" do
        do_patch
        granted_roles = assigns(:membership).application_memberships.map(&:roles).flatten
        expect(granted_roles).to eq(["wookie_wrangler"])
      end
    end
  end
end
