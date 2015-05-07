rota_oauth_app = Doorkeeper::Application.where(name: "Rota").first_or_create!(
  uid: ENV.fetch("ROTA_UID"),
  secret: ENV.fetch("ROTA_SECRET"),
  redirect_uri: ENV.fetch("ROTA_REDIRECT_URI"))
GovernmentApplication.where(oauth_application: rota_oauth_app).first_or_create!

service_oauth_app = Doorkeeper::Application.where(name: "Service").first_or_create!(
  uid: ENV.fetch("SERVICE_UID"),
  secret: ENV.fetch("SERVICE_SECRET"),
  redirect_uri: ENV.fetch("SERVICE_REDIRECT_URI"))
GovernmentApplication.where(oauth_application: service_oauth_app).first_or_create!
