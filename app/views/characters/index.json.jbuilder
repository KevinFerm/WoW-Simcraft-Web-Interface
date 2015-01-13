json.array!(@characters) do |character|
  json.extract! character, :id, :name, :region, :realm
  json.url character_url(character, format: :json)
end
