require 'nokogiri'

class Scrape
  attr_reader :found_recipes, :found_recipes_desc
  def initialize
    @found_recipes = []
    @found_recipes_desc = []
  end

  def add_from_site(search_string)
    scrape_recipe(search_string)
  end

  def find_recipe
    scrape_time(@urls[save_recipe_index[0]])
    saved_recipe(save_recipe_index[0], save_recipe_index[1], @time)
    new_recipe = Recipe.new(@to_be_recipe[0], @to_be_recipe[1], @to_be_recipe[2], @to_be_recipe[3])
    @cookbook.add_recipe(new_recipe)
  end

  def scrape_recipe(keyword)
    Kernel.system "curl --silent 'https://www.allrecipes.com/search/?wt=#{keyword}' > lib/htmls/#{keyword}.html"
    doc = Nokogiri::HTML(File.open("lib/htmls/#{keyword}.html"), nil, 'utf-8')
    new_recipes = doc.search('.fixed-recipe-card__info .fixed-recipe-card__title-link').text.strip.split("\r\n")
    @found_recipes = new_recipes.map { |e| e.strip }.map.with_index { |e, index| index.even? ? e : nil }
    @found_recipes.delete(nil)
    @found_recipes_desc = doc.search('.fixed-recipe-card__description').map { |e| e.text }
  end
end
