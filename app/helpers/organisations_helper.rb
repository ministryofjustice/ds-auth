module OrganisationsHelper
  def options_for_organisation_type
    Organisation::ORGANISATION_TYPES.collect { |t| [t("organisation_types.#{t}"), t] }
  end

  def options_for_parent_organisation
    Organisation.all.collect { |o| [ o.name, o.id ] }
  end

  def organisation_type(organisation)
    t("organisation_types.#{@organisation.organisation_type}")
  end
end
