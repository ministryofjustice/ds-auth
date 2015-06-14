class Role < Struct.new(:name, :applications)

  def <=>(other)
    name <=> other.name
  end
end
