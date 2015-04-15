class ProfilesSerializer < CollectionSerializer

  def serialize
    collection.map do |p|
      ProfileSerializer.new(p).serialize
    end
  end

  private

  def root_key
    :profiles
  end
end
