class BaseSerializer
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def as_json(opts = {})
    {
      root_key.to_sym => serialize
    }
  end

  def serialize
    raise NotImplementedError.new("Extending serializers must implement #serialize")
  end

  private

  def root_key
    object.class.name.underscore
  end
end
