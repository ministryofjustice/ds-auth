module OrganisationsHelper
  def options_for_parent_organisation
    Organisation.all.collect { |o| [ o.name, o.id ] }
  end
end
