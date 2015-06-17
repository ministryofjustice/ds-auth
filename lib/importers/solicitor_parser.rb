require "csv"

module Importers
  class SolicitorParser
    def initialize(filename)
      @filename = filename
    end

    def import!
      file_to_hash
    end

    private

    attr_reader :filename

    def file_to_hash
      csv_rows = CSV.parse(File.open(filename, "r"), headers: true)

      results = {}
      csv_rows.each do |row|
        org_name = row[0]
        results[org_name] ||= organisation_attributes(org_name)
        results[org_name][:users][user_email(row)] = user_attributes(row)
      end

      results
    end

    def organisation_attributes(org_name)
      {
        slug: generate_slug(org_name),
        organisation_type: "law_firm",
        users: {}
      }
    end

    def user_email(row)
      row[4]
    end

    def user_attributes(row)
      {
        name: row[1],
        telephone: row[3]
      }
    end

    def generate_slug(org_name)
      org_name.gsub(/[^\w\s]+/, "").gsub(/\s+/, "-").downcase
    end
  end
end
