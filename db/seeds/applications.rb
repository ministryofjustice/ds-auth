Doorkeeper::Application.where(name: "drs-rota").first_or_create!(
  uid: ENV.fetch("ROTA_UID"),
  secret: ENV.fetch("ROTA_SECRET"),
  redirect_uri: ENV.fetch("ROTA_REDIRECT_URI")
)

Doorkeeper::Application.where(name: "drs-service").first_or_create!(
  uid: ENV.fetch("SERVICE_UID"),
  secret: ENV.fetch("SERVICE_SECRET"),
  redirect_uri: ENV.fetch("SERVICE_REDIRECT_URI")
)

Doorkeeper::Application.where(name: "adp").first_or_create!(
  uid: ENV.fetch("ADP_UID"),
  secret: ENV.fetch("ADP_SECRET"),
  redirect_uri: ENV.fetch("ADP_REDIRECT_URI")
)
