Role = Struct.new(:name, :applications) do

  def <=>(other)
    name <=> other.name
  end

end
