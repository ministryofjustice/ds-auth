class RoleLoader

  def available_roles_for_application(name)
    load_organisation_types.map do |organisation_type, data|
      data["available_roles"].map do |role_name, applications|
        Role.new name: role_name, applications: applications if applications.include?(name)
      end
    end.flatten.compact.uniq.sort
  end

  def available_roles_for_organisation_type(organisation_type)
    (organisation_type_data(organisation_type)["available_roles"].map do |name, applications|
      Role.new name: name, applications: applications
    end) + default_available_roles
  end

  def default_roles_for_organisation_type(organisation_type)
    organisation_type_data(organisation_type)["default_roles"] + default_organisation_roles
  end

  private

  def load_organisation_types
    @load_organisation_types ||= YAML::load File.open(::Rails.root + organisation_types_file)
  end

  def organisation_types_file
    ENV.fetch("ORGANISATION_FILE_PATH") { "config/organisation_types.yml" }
  end

  def default_available_roles
    load_organisation_types["default"]["available_roles"].map do |name, applications|
      Role.new name: name, applications: applications
    end
  end

  def default_organisation_roles
    load_organisation_types["default"]["default_roles"]
  end

  def organisation_type_data(organisation_type)
    load_organisation_types[organisation_type]
  end

end
