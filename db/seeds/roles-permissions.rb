cso_role = Role.where(name: "cso").first_or_create!
cco_role = Role.where(name: "cco").first_or_create!
solicitor_role = Role.where(name: "solicitor").first_or_create!
laa_role = Role.where(name: "laa").first_or_create!

rota_app = Doorkeeper::Application.find_by(name: "Rota")
service_app = Doorkeeper::Application.find_by(name: "Service")

(1..5).each do |i|
  Permission.where(role: cso_role,
                   user: User.where(email: "cso#{i}@example.com").first,
                   application: service_app,
                   organisation: Organisation.where(slug: "custody-suite").first
                  ).first_or_create

  Permission.where(role: cco_role,
                   user: User.where(email: "cco#{i}@example.com").first,
                   application: service_app,
                   organisation: Organisation.where(slug: "capita").first,
                  ).first_or_create

  Permission.where(role: solicitor_role,
                   user: User.where(email: "solicitor#{i}@example.com").first,
                   application: service_app,
                   organisation: Organisation.where(slug: "law-firm").first
                  ).first_or_create

  Permission.where(role: laa_role,
                   user: User.where(email: "laa#{i}@example.com").first,
                   application: rota_app,
                   organisation: Organisation.where(slug: "laa")
                  ).first_or_create
end
