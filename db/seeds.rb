# %w[users organisations applications roles-permissions].each do |seed|
%w[users applications].each do |seed|
  puts "Seeding #{seed.titleize.humanize}..."
  load "#{Rails.root}/db/seeds/#{seed}.rb"
end
