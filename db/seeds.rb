%w[users organisations memberships-permissions].each do |seed|
  puts "Seeding #{seed.titleize.humanize}..."
  load "#{Rails.root}/db/seeds/#{seed}.rb"
end
