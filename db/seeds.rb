# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

tester = User.create(
  username: 'tester',
  email: 'test@example.com',
  admin: true,
  password: 'password123',
  password_confirmation: 'password123'
)

cottolin, wool, linen = %w(cottolin 6_2_tuna 16_1_linen).map do |yarn|
  Yarn.create(YAML.load_file("lib/data/#{yarn}.yml"))
end

patterns = Pattern.create(
  name: "Vertical Stripes",
  yarn: cottolin,
  user: tester,
  stripes: [{ color: "2000", width: 1}, { color: "2005", width: 1}]
)