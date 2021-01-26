require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require 'json'
require_relative 'lib/cookbook'
require_relative 'lib/recipe'
require_relative 'lib/scrape'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end

new_cookbook = Cookbook.new('lib/recipes.csv')
new_scrape = Scrape.new

get '/' do
  @recipes = new_cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  new_recipe = Recipe.new(params['recipe-title'], params['description'], params['recipe-rating'],
                          params['prepare-time'])
  new_cookbook.add_recipe(new_recipe)
  redirect '/'
end

get '/search' do
  @scraped_hash = []
  erb :search
end

post '/search' do
  @scraped_hash = new_scrape.add_from_site(params['search'])
  redirect "/search/#{params['search']}"
end

get '/search/:search_item' do
  @recipes = new_scrape.found_recipes
  @rec_desc = new_scrape.found_recipes_desc
  erb :search_results
end

get '/search/:search_item/add/:index' do
  @index = params[:index].to_i
  @recipe_name = new_scrape.found_recipes[@index]
  @recipe_description = new_scrape.found_recipes_desc[@index]
  erb :add_from_search
end

post '/search/:search_item/add/:index' do
  index = params['index_value'].to_i
  recipe_name = new_scrape.found_recipes[index]
  recipe_description = new_scrape.found_recipes_desc[index]
  recipe = Recipe.new(recipe_name, recipe_description, params['rate-this-recipe'], params['preparation-time'])
  new_cookbook.add_recipe(recipe)
  redirect '/'
end

post '/delete/:index' do
  index = params['delete-value'].to_i
  new_cookbook.remove_recipe(index)
  redirect '/'
end

get '/about' do
  erb :about
end
