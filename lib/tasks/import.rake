require_relative "../importers/solicitor_parser"

namespace :import do
  desc "Import Kent members list from CSV"
  task kent_members: :environment do
    organisation_attrs = Importers::SolicitorParser.new(File.join(Rails.root, "fixtures", "kent_members_list.csv")).import!

    Importers::SolicitorImporter.create_from_attributes(organisation_attrs)
  end
end
