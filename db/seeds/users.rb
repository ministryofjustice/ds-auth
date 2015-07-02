User.where(email: "webops@example.com").first_or_create!(
  password: "password",
  name: "Webops user",
  address: "Fake Street",
  postcode: "POSTCODE",
  email: "webops@example.com",
  telephone: "01234567890",
  mobile: "07123456789"
)

# Create 5 CSOs, CCOs, LAA Rota team members, and solicitors
(1..5).each do |i|
  User.where(email: "cso#{i}@example.com").first_or_create!(
    password: "password",
    name: "CSO ##{i}",
    address: "#{i} Fake Street",
    postcode: "POSTCODE",
    email: "cso#{i}@example.com",
    telephone: "01234567890",
    mobile: "07123456789"
  )

  User.where(email: "cco#{i}@example.com").first_or_create!(
    password: "password",
    name: "CCO ##{i}",
    address: "#{i} Fake Street",
    postcode: "POSTCODE",
    email: "cco#{i}@example.com",
    telephone: "01234567890",
    mobile: "07123456789"
  )

  User.where(email: "solicitor#{i}@example.com").first_or_create!(
    password: "password",
    name: "Solicitor ##{i}",
    address: "#{i} Fake Street",
    postcode: "POSTCODE",
    email: "solicitor#{i}@example.com",
    telephone: "01234567890",
    mobile: "07123456789"
  )

  User.where(email: "laa#{i}@example.com").first_or_create!(
    password: "password",
    name: "LAA #{i}",
    address: "#{i} Fake Street",
    postcode: "POSTCODE",
    email: "laa#{i}@example.com",
    telephone: "09011105010",
    mobile: "07123456789"
  )

end

  User.where(email: "caseworker@example.com").first_or_create!(
    password: "password",
    name: "LAA Caseworker",
    address: "Fake Street",
    postcode: "POSTCODE",
    email: "caseworker@example.com",
    telephone: "09011105010",
    mobile: "07123456789"
  )
