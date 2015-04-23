module OrganisationsHelper
  def options_for_organisation_type
    Organisation::ORGANISATION_TYPES
  end

  def options_for_parent_organisation
    Organisation.all.collect { |o| [ o.name, o.id ] }
  end
end
