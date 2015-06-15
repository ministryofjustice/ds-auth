class Role
  attr_accessor :name, :application

  def initialize(params = {})
    @name, @application = params[:name], params[:application]
  end

  def <=>(other)
    name <=> other.name
  end
end
