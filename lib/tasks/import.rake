require_relative "../importers/solicitor_importer"

namespace :import do
  desc "Import Kent members list from CSV"
  task kent_members: :environment do
    organisation_attrs = Importers::SolicitorImporter.new(File.join(Rails.root, "fixtures", "kent_members_list.csv")).import!

    Organisation.create_from_attributes(organisation_attrs)
  end
end
