class UsersSerializer < CollectionSerializer

  def serialize
    collection.map do |u|
      UserSerializer.new(u).serialize
    end
  end

  private

  def root_key
    :users
  end
end
