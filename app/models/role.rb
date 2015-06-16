class Role
  attr_accessor :name, :applications

  def initialize(params = {})
    @name, @applications = params[:name], Array(params[:applications])
  end

  def <=>(other)
    name <=> other.name
  end
end
