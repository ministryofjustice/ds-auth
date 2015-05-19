example_org = Organisation.where(slug: "example-org").first_or_create!(
  name: "Example Org",
  organisation_type: "law_office",
  tel: "11 88 88")

Membership.create(organisation: example_org, profile: Profile.where(email: "jeff@example").first)

custody_suite = Organisation.where(slug: "custody-suite").first_or_create!(
  name: "Custody Suite",
  organisation_type: "custody_suite",
  tel: "118 247"
)

call_centre = Organisation.where(slug: "capita").first_or_create!(
  name: "Capita",
  organisation_type: "call_centre",
  tel: "118 118"
)

law_firm = Organisation.where(slug: "law-firm").first_or_create!(
  name: "Law Firm",
  organisation_type: "law_firm",
  tel: "09011105010"
)

laa = Organisation.where(slug: "laa").first_or_create!(
  name: "Legal Aid Agency",
  organisation_type: "civil",
  tel: "03069 990919"
)

(1..5).each do |i|
  Membership.create(
    organisation: custody_suite,
    profile: Profile.where(email: "cso#{i}@example.com").first
  )

  Membership.create(
    organisation: call_centre,
    profile: Profile.where(email: "cco#{i}@example.com").first
  )

  Membership.create(
    organisation: law_firm,
    profile: Profile.where(email: "solicitor#{i}@example.com").first
  )

  Membership.create(
    organisation: laa,
    profile: Profile.where(email: "laa#{i}@example.com").first
  )
end
