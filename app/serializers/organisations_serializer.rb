class OrganisationsSerializer < CollectionSerializer

  def serialize
    collection.map do |o|
      OrganisationSerializer.new(o).serialize
    end
  end

  private

  def root_key
    :organisations
  end
end
