module CharactersHelper
  def char_link(char, options = {})
    char_path options.merge(char_options(char))
  end
  def char_options(char)
    {:region => char['region'], :realm => char['realm'], :name => char['name']}
  end
end
