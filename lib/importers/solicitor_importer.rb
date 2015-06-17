module Importers
  class SolicitorImporter
    def self.create_from_attributes(orgs_attrs)
      Organisation.transaction do
        orgs_attrs.each_pair do |org_name, org_attrs|
          users_attrs = org_attrs.delete(:users)

          org = Organisation.where(name: org_name).first_or_initialize do |o|
            o.assign_attributes(org_attrs)
          end

          unless org.save
            puts "Error whilst saving Organisation: #{org_name}." unless Rails.env.test?
            raise ActiveRecord::Rollback
          end

          users_attrs.each_pair do |user_email, user_attrs|
            user = User.where(email: user_email).first_or_initialize do |u|
              u.assign_attributes(user_attrs)
              u.password = u.password_confirmation = Devise.friendly_token.first(8)
            end

            unless user.save
              puts "Error whilst saving User: #{user_email}." unless Rails.env.test?
              raise ActiveRecord::Rollback
            end

            Membership.where(user_id: user.id, organisation_id: org.id).first_or_create! do |m|
              m.roles = ["solicitor_admin"]
            end
          end
        end
      end
    end
  end
end
