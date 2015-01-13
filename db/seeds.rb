# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'json'
char_data = JSON.parse(File.read("#{Rails.root}/app/assets/seed/netfive.json"))
Character.new({
                     name:char_data['name'],
                     region:"eu",
                     realm:char_data['realm'],
                     charClass:char_data['class'],
                     race:char_data['race'],
                     level:char_data['level'],
                     achievementPoints:char_data['achievementPoints'],
                     items:char_data['items'],
                     stats:char_data['stats'],
                     hunterPets:char_data['hunterPets'],
                     talents:char_data['talents'],
                     progression:char_data['progression'],
                 }).save
# chara.name = char_data['name'].to_s
# chara.realm = char_data['realm'].to_s
# chara.class = char_data['class'].to_i
# chara.race = char_data['race'].to_i
# chara.level = char_data['level'].to_i
# chara.achievementPoints = char_data['achievementPoints'].to_i
# #chara.items = char_data['items']
# #chara.stats = char_data['stats']
# #chara.hunterPets = char_data['hunterPets']
# #chara.talents = char_data['talents']
# #chara.progression = char_data['progression']
# chara.save!