# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

vavstuga = User.create(
  username: 'vavstuga',
  email: 'office@vavstuga.com',
  admin: true,
  password: 'vavstuga',
  password_confirmation: 'vavstuga'
)

cottolin = Yarn.create(
  name: "Cottolin",
  size: "22/2",
  slug: "th-yarn-bock-cot-lin-22-2",
  colors: [
    { code: '2023', name: 'Boysenberry' },
    { code: '2005', name: 'Black' },
    { code: '2000', name: 'Ivory' },
    { code: '2071', name: 'Gold' },
    { code: '2035', name: 'Aqua' }
  ]
)

patterns = Pattern.create(
  name: "Vertical Stripes",
  yarn: cottolin,
  user: vavstuga,
  stripes: [{ color: "2000", width: 1}, { color: "2005", width: 1}]
)