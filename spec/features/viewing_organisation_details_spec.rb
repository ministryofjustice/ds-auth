require "rails_helper"

RSpec.feature "Viewing an organisations details" do
  let!(:user) { create :user }
  let!(:organisation) { create :organisation }

  before do
    login_as_user user.email, user.password
  end

  context "a User that belongs to the Organisation" do
    before do
      create :membership, user: user, organisation: organisation
    end

    specify "can view relevant details on a show page" do
      visit organisations_path

      within "#organisation_#{organisation.id}" do
        click_link "Show"
      end

      expect(page).to have_content "Name: #{organisation.name}"
      expect(page).to have_content "Slug: #{organisation.slug}"

      expect(page).to have_content "Members"
      organisation.users.each do |u|
        expect(page).to have_content u.name
      end
    end

    context "when the Organisation has parent and child organisations" do
      let!(:organisation) { create :organisation, parent_organisation: parent }
      let(:parent) { create :organisation }

      specify "can view parent and child organisations and links on a show page" do
        create_list :organisation, 3, parent_organisation: organisation

        visit organisation_path(organisation)

        expect(page).to have_content "Name: #{organisation.name}"
        expect(page).to have_content "Parent Organisation: #{parent.name}"
        expect(page).to have_link parent.name, href: organisation_path(parent)

        expect(page).to have_content "Suborganisations:"
        organisation.sub_organisations.each do |so|
          expect(page).to have_content so.name
          expect(page).to have_link so.name, href: organisation_path(so)
        end
      end
    end
  end
end
