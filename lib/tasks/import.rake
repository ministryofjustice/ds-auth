require_relative "../importers/solicitor_parser"
require_relative "../importers/solicitor_importer"

namespace :import do
  desc "Import Kent members list from CSV"
  task :kent_members, [:file_path] => :environment do |t, args|
    organisation_attrs = Importers::SolicitorParser.new(File.join(Rails.root, args[:file_path])).import!

    Importers::SolicitorImporter.create_from_attributes(organisation_attrs)
  end
end
