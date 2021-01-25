class Recipe
  attr_reader :name, :description, :rating, :complete, :time_to_cook

  def initialize(name, description, rating, time_to_cook)
    @name = name
    @description = description
    @rating = rating
    @time_to_cook = time_to_cook
    @complete = false
  end

  def complete!
    @complete = true
  end
end
