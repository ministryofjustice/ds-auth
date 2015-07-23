class CreateUserWithoutMembership
  def initialize(attrs={})
    @name     = attrs[:name]
    @email    = attrs[:email]
    @password = attrs[:password]
  end

  def call
    if all_attributes_present?
      User.create!(
        name: name,
        email: email,
        password: password,
        is_webops: true
      )
    else
      raise "Requires name, email, and password to be provided as arguments." if %w{name email password}.any? { |k| ENV[k].nil? }
    end
  end

  private

  attr_reader :name, :email, :password

  def all_attributes_present?
    [@name, @email, @password].all?(&:present?)
  end
end
