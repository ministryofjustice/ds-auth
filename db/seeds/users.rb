# Test user
User.where(email: "user@example.com").first_or_create(
  email: "user@example.com", password: "password")

# Test user with a profile assocaited
user2 = User.where(email: "user2@example.com").first_or_create(
  email: "user2@example.com", password: "password")

Profile.where(user: user2).first_or_create(
  name: "Jeff",
  address: "123 Fake Street",
  postcode: "POSTCODE",
  email: "jeff@example.com",
  tel: "09011105010",
)

# Create 5 CSOs, CCOs, and solicitors
(1..5).each do |i|
  cso = User.where(email: "cso#{i}@example.com").first_or_create(password: "password")
  Profile.where(user: cso).first_or_create(
    name: "CSO ##{i}",
    address: "#{i} Fake Street",
    postcode: "POSTCODE",
    email: "cso#{i}@example.com",
    tel: "01234567890",
    mobile: "07123456789"
  )

  cco = User.where(email: "cco#{i}@example.com").first_or_create(password: "password")
  Profile.where(user: cco).first_or_create(
    name: "CCO ##{i}",
    address: "#{i} Fake Street",
    postcode: "POSTCODE",
    email: "cco#{i}@example.com",
    tel: "01234567890",
    mobile: "07123456789"
  )

  solicitor = User.where(email: "solicitor#{i}@example.com").first_or_create(password: "password")
  Profile.where(user: solicitor).first_or_create(
    name: "Solicitor ##{i}",
    address: "#{i} Fake Street",
    postcode: "POSTCODE",
    email: "solicitor#{i}@example.com",
    tel: "01234567890",
    mobile: "07123456789"
  )

  laa = User.where(email: "laa#{i}@example.com").first_or_create(password: "password")
  Profile.where(user: laa).first_or_create(
    name: "LAA #{i}",
    address: "#{i} Fake Street",
    postcode: "POSTCODE",
    email: "laa#{i}@example.com",
    tel: "09011105010",
    mobile: "07123456789"
  )
end
