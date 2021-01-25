require_relative 'recipe'
require 'csv'

class Cookbook
  attr_reader :recipes

  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    load_csv
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    add_to_csv(recipe)
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index - 1)
    delete_from_csv(recipe_index)
  end

  private

  def add_to_csv(recipe)
    CSV.open(@csv_file_path, "ab") do |csv|
      csv << [recipe.name, recipe.description, recipe.rating, recipe.time_to_cook]
    end
  end

  def delete_from_csv(recipe_index)
    d = []
    CSV.read(@csv_file_path).each do |each_row|
      d << each_row
    end
    d.delete_at(recipe_index)
    CSV.open(@csv_file_path, "wb") do |csv|
      d.each { |recipe| csv << recipe }
    end
  end

  def load_csv
    CSV.read(@csv_file_path).each_with_index do |e, i|
      next if i.zero?

      new_recipe = Recipe.new(e[0], e[1], e[2], e[3])
      @recipes << new_recipe
    end
  end
end
