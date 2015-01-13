module Wowchar
  class Wowapi
    require 'httparty'
    #getchar("eu","/wow/character/realm/charactername", params)
    def self.getchar(region,charlink, params = "items,stats,progression,stats,hunterPets,talents")
      #Sets region url
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

      url = "https://" + bnet + charlink +"?"+ params
      chardat = HTTPARTY.get(url)
      chardata = JSON.parse(chardat.body)
      return chardata


    end

  end

end