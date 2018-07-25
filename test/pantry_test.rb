require './lib/pantry'
require './lib/recipe'
require 'minitest/autorun'
require 'minitest/pride'

class PantryTest < Minitest::Test

  def test_pantry_exists
    pantry = Pantry.new
    assert_instance_of Pantry, pantry
  end

  def test_stock_starts_empty
    pantry = Pantry.new
    assert_equal ({}), pantry.stock
  end

  def test_can_check_stock
    pantry = Pantry.new
    pantry.stock_check("Cheese")
    assert_equal 0,   pantry.stock_check("Cheese")
  end

  def test_can_restock
    pantry = Pantry.new
    pantry.restock("Cheese", 10)
    pantry.stock_check("Cheese")
    assert_equal 10, pantry.stock_check("Cheese")
  end

  def test_it_can_keep_restocking
    pantry = Pantry.new
    pantry.restock("Cheese", 10)
    pantry.stock_check("Cheese")
    pantry.restock("Cheese", 20)
    pantry.stock_check("Cheese")

    assert_equal 30, pantry.stock_check("Cheese")
  end

  def test_can_build_recipe
    pantry = Pantry.new
    r = Recipe.new("Cheese Pizza")
    assert_equal ({}), r.ingredients
  end

  def test_it_can_add_ingredients_to_list
    pantry = Pantry.new
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 20)
    pantry.add_to_shopping_list(r)
    expected = {"Cheese" => 20, "Flour" => 20}
    assert_equal expected, pantry.shopping_list
  end

  def test_it_can_add_more_ingredients_to_list
      pantry = Pantry.new
      recipe_p = Recipe.new("Cheese Pizza")
      recipe_p.add_ingredient("Cheese", 20)
      recipe_p.add_ingredient("Flour", 20)

      recipe_s = Recipe.new("Spaghetti")
      recipe_s.add_ingredient("Spaghetti Noodles", 10)
      recipe_s.add_ingredient("Marinara Sauce", 10)
      recipe_s.add_ingredient("Cheese", 5)

      pantry.add_to_shopping_list(recipe_p)
      pantry.add_to_shopping_list(recipe_s)

      expected = {
        "Cheese" => 25,
        "Flour" => 20,
        "Spaghetti Noodles" => 10,
        "Marinara Sauce" => 10
      }
      assert_equal expected, pantry.shopping_list
  end

  def test_can_print_shopping_list
    pantry = Pantry.new
    recipe_p = Recipe.new("Cheese Pizza")
    recipe_p.add_ingredient("Cheese", 20)
    recipe_p.add_ingredient("Flour", 20)

    recipe_s = Recipe.new("Spaghetti")
    recipe_s.add_ingredient("Spaghetti Noodles", 10)
    recipe_s.add_ingredient("Marinara Sauce", 10)
    recipe_s.add_ingredient("Cheese", 5)

    pantry.add_to_shopping_list(recipe_p)
    pantry.add_to_shopping_list(recipe_s)

    expected = "* Cheese: 25\n* Flour: 20\n* Spaghetti Noodles: 10\n* Marinara Sauce: 10"
    assert_equal expected, pantry.print_shopping_list

  end

  def test_it_can_add_to_cookbook
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)

    assert [r1, r2, r3], pantry.cookbook
  end

  def test_it_can_make_reccomendations
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)

    pantry.restock("Cheese", 10)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Cucumbers", 120)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)

    expected = ["Pickles", "Peanuts"]

    assert_equal expected, pantry.what_can_i_make
  end




end
