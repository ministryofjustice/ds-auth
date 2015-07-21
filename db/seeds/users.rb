User.where(email: "admin@example.com").first_or_create!(
  password: "password",
  name: "Default Webops user",
  address: "Fake Street",
  postcode: "POSTCODE",
  email: "webops@example.com",
  telephone: "01234567890",
  mobile: "07123456789"
)
