custody_suite = Organisation.where(slug: "custody-suite").first
call_centre = Organisation.where(slug: "capita").first
laa = Organisation.where(slug: "laa").first
law_firm_1 = Organisation.where(slug: "law-firm-1").first

(1..5).each do |i|
  cso = Membership.create(
    organisation: custody_suite,
    user: User.where(email: "cso#{i}@example.com").first,
    roles: %w(cso)
  )
  cso.update roles: %w(cso admin) if i == 1


  cco = Membership.create(
    organisation: call_centre,
    user: User.where(email: "cco#{i}@example.com").first,
    roles: %w(operator)
  )
  cco.update roles: %w(operator admin) if i == 1

  solicitor = Membership.create(
    organisation: law_firm_1,
    user: User.where(email: "solicitor#{i}@example.com").first,
    roles: %w(solicitor)
  )
  solicitor.update roles: %w(solicitor_admin admin) if i == 1

  laa_team_member = Membership.create(
    organisation: laa,
    user: User.where(email: "laa#{i}@example.com").first,
    roles: %w(rotaTeam)
  )
  laa_team_member.update roles: %w(rotaTeam admin) if i == 1
end
