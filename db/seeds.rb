# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
vavstuga = User.create(username: 'vavstuga', email: 'office@vavstuga.com', admin: true, password: 'vavstuga', password_confirmation: 'vavstuga')
cottolin = Yarn.create(name: "Cottolin", size: "22/2")
patterns = Pattern.create(name: "Swedish Kitchen", yarn: cottolin, user: vavstuga)