Organisation.where(slug: "webops").first_or_create!(
  name: "Webops",
  organisation_type: "webops"
)

Organisation.where(slug: "custody-suite").first_or_create!(
  name: "Custody Suite",
  organisation_type: "custody_suite",
  tel: "118 247"
)

Organisation.where(slug: "capita").first_or_create!(
  name: "Capita",
  organisation_type: "drs_call_center",
  tel: "118 118"
)

(1..3).each do |i|
  Organisation.where(slug: "law-firm-#{i}").first_or_create!(
    name: "Law Firm #{i}",
    organisation_type: "law_firm",
    tel: "09011105010"
  )
end

Organisation.where(slug: "laa").first_or_create!(
  name: "Legal Aid Agency",
  organisation_type: "laa_rota_team",
  tel: "03069 990919"
)
