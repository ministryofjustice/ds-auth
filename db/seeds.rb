# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#Test user
User.where(email: "user@example.com").first_or_create(
  email: "user@example.com", password: "password")


user2 = User.where(email: "user2@example.com").first_or_create(
  email: "user2@example.com", password: "password")

profile = Profile.where(user: user2).first_or_create(
  name: "Jeff",
  address: "123 Fake Street",
  postcode: "POSTCODE",
  email: "jeff@example.com",
  tel: "09011105010",
)

rota_oauth_app = Doorkeeper::Application.where(name: "Rota").first_or_create(
  uid: ENV.fetch("ROTA_UID"),
  secret: ENV.fetch("ROTA_SECRET"),
  redirect_uri: ENV.fetch("ROTA_REDIRECT_URI"))
GovernmentApplication.where(oauth_application: rota_oauth_app).first_or_create

service_oauth_app = Doorkeeper::Application.where(name: "Service").first_or_create(
  uid: ENV.fetch("SERVICE_UID"),
  secret: ENV.fetch("SERVICE_SECRET"),
  redirect_uri: ENV.fetch("SERVICE_REDIRECT_URI"))
GovernmentApplication.where(oauth_application: service_oauth_app).first_or_create

example_org = Organisation.where(slug: "example-org").first_or_create(
  name: "Example Org",
  organisation_type: "social")
membership = Membership.create(organisation: example_org, profile: profile)
example_org.memberships << membership

role = Role.where(name: 'admin').first_or_create

Permission.where(role: role,
                 user: user2,
                 government_application: service_oauth_app,
                 orgnaisation: example_org).first_or_create
Permission.where(role: role,
                 user: user2,
                 government_application: rota_oauth_app,
                 orgnaisation: example_org).first_or_create

