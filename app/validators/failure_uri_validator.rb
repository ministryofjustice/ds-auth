require "uri"

class FailureUriValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present?
      value.split.each do |val|
        uri = ::URI.parse(val)
        record.errors.add(attribute, :fragment_present) unless uri.fragment.nil?
        record.errors.add(attribute, :relative_uri) if uri.scheme.nil? || uri.host.nil?
        record.errors.add(attribute, :secured_uri) if invalid_ssl_uri?(uri)
      end
    end
  rescue URI::InvalidURIError
    record.errors.add(attribute, :invalid_uri)
  end

  private

  def invalid_ssl_uri?(uri)
    forces_ssl = Doorkeeper.configuration.force_ssl_in_redirect_uri
    forces_ssl && uri.try(:scheme) == "http"
  end
end
