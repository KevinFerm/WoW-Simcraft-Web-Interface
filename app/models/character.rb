require 'httparty'
class Character < ActiveRecord::Base
  include HTTParty
  require 'net/http'

  serialize :items, JSON
  serialize :stats, JSON
  serialize :hunterPets, JSON
  serialize :talents, JSON
  serialize :progression, JSON
  serialize :professions, JSON

  REGIONS = ['us', 'eu', 'kr', 'tw', 'cn', 'sea']
  MAX_LEVEL = 100

  validates_presence_of :realm
  validates_presence_of :name
  validates_presence_of :items
  validates_presence_of :region
  def self.normalize_realm(realm)
    realm.downcase.gsub(/['’]/, '').gsub(/ /, '-').gsub(/[àáâãäå]/, 'a').gsub(/[ö]/, 'o')
  end

  def self.normalize_character(character)
    character.downcase
  end
  def self.createChar(region,charlink,params="items,stats,stats,hunterPets,talents,professions,progression")
    char_data = getCharData(normalize_character(region),charlink,params)
    puts "JSON:" + char_data['professions'].to_s
    if char_data == "Character not found" then
      return false
    end
    if char_data != "Character not found" then
      newchar = Character.new({
                        name:normalize_realm(char_data['name'].titleize),
                        region:normalize_character(region),
                        realm:normalize_realm(char_data['realm'].titleize),
                        charClass:char_data['class'],
                        professions:char_data['professions'],
                        thumbnail:char_data['thumbnail'],
                        gender:char_data['gender'],
                        calcClass:char_data['calcClass'],
                        race:char_data['race'],
                        level:char_data['level'],
                        achievementPoints:char_data['achievementPoints'],
                        items:char_data['items'],
                        stats:char_data['stats'],
                        hunterPets:char_data['hunterPets'],
                        talents:char_data['talents']
                    }).save
      if(char_data && newchar)
        return char_data
      end

    else
      puts char_data
      return false
    end
  end

  def self.getCharData(region,realm,name, params = "items,stats,progression,stats,hunterPets,talents,professions")
    #Sets region url
    char = Character.where(region: normalize_character(region), name: normalize_character(name).titleize, realm: normalize_realm(realm).titleize).first
    if(region.blank? or realm.blank? or name.blank?)
      puts "You dun fucked up!"
    else
      if(char.nil?)
        puts "yosup WHY IS THIS NOT NIL"
        charlink = "/wow/character/"+normalize_realm(realm)+"/"+normalize_character(name)
        if(region == "eu")
          bnet = "eu.battle.net/api"
        elsif(region == "us")
          bnet = "us.battle.net/api"
        elsif(region == "tw")
          bnet = "tw.battle.net/api"
        elsif(region == "kr")
          bnet = "kr.battle.net/api"
        elsif(region == "cn")
          bnet = "cn.battle.net/api"
        elsif(region == "sea" )
          bnet = "sea.battle.net/api"
        end

        url = "https://" + bnet + charlink +"?fields="+params
        chardat = Net::HTTP.get_response(URI.parse(url))
        chardata = JSON.parse(chardat.body)
        if(chardata['name'].nil?) then
          return "Character not found"
        end
        chardata['region'] = normalize_character(region)
        return chardata
      else
        return char
      end
    end
  end

  def self.getchar(region,realm,name)
    #Sets region url
    char = Character.where(region: normalize_character(region), name: normalize_character(name), realm: normalize_realm(realm)).take
    puts "testing CHAR"
    puts char.inspect
    if(region.blank? or realm.blank? or name.blank?)
      puts "You dun fucked up!"
    else
      if(char.nil?)
        return char
      else
        return char
      end
    end



  end
end
