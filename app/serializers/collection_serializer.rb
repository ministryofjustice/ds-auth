class CollectionSerializer
  attr_reader :collection

  def initialize(collection)
    @collection = collection
  end

  def as_json(opts = {})
    {
      root_key => serialize
    }
  end

  def serialize
    raise NotImplementedError.new("Extending serializers must implement #serialize")
  end

  private

  def root_key
    raise NotImplementedError.new("Extending serializers must implement #root_key")
  end
end
