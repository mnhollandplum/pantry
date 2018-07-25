require 'pry'
class Pantry
    attr_reader :stock,
                :shopping_list,
                :cookbook
  def initialize
    @stock = Hash.new(0)
    @shopping_list = Hash.new(0)
    @cookbook = []
  end

  def stock_check(item)
    @stock[item]
  end

  def restock(item, amount)
    @stock[item] += amount
  end

  def add_to_shopping_list(r)
    r.ingredients.map do |item, amount|
      @shopping_list[item] += amount
    end
  end

  def print_shopping_list
    printed_list = []
    @shopping_list.each do |item, amount|
      printed_list << "* #{item}: #{amount}"
    end
    printed_list.join("\n")
  end

  def add_to_cookbook(r)
    @cookbook << r
  end

  def what_can_i_make
    have_enough_ingredients.map do |r|
      r.name
    end
  end

  def have_enough_ingredients
    @cookbook.find_all do |r|
      r.ingredients.all? do |item, amount|
        @stock[item] >= amount
      end
    end
  end



end
