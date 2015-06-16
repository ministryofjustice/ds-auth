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
            puts "Error whilst saving Organisation: #{org_name}."
            raise ActiveRecord::Rollback
          end

          users_attrs.each do |user_attrs|
            user = User.where(email: user_attrs[:email]).first_or_initialize do |u|
              u.assign_attributes(user_attrs)
            end

            unless user.save
              puts "Error whilst saving User: #{user_attrs[:name]}."
              raise ActiveRecord::Rollback
            end

            Membership.where(user_id: user.id, organisation_id: org.id).first_or_create! do |m|
              m.roles = org.default_role_names
            end
          end
        end
      end
    end
  end
end
