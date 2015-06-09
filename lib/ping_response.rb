class PingResponse
  VERSION_FILE = "/.version.yml"

  UNKNOWN_VERSION_DATA_RESPONSE = {
    version_number: "unknown",
    build_date: nil,
    commit_id: "unknown",
    build_tag: "unknown"
  }

  attr_reader :ok, :data
  alias :ok? :ok

  def initialize
    begin
      @data = YAML.load_file(VERSION_FILE)
      @ok = true
    rescue
      @data = UNKNOWN_VERSION_DATA_RESPONSE
      @ok = false
    end
  end
end
