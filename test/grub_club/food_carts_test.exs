defmodule GrubClub.FoodCartsTest do
  @moduledoc """
  FoodCarts context test file
  """

  use ExUnit.Case

  alias GrubClub.FoodCarts

  setup_all do
    valid_keys = [:address, :applicant, :food_items, :latitude, :longitude, :zip_code]

    {:ok, data: FoodCarts.get_food_carts(), valid_keys: valid_keys}
  end

  describe("get_food_carts/0") do
    # Test cases for the get_food_carts/0 function in the FoodCarts context
    test "get_food_carts/0 returns all records in data file", state do
      assert Enum.count(state.data) == 481
    end

    test "get_food_carts/0 returns only data from valid keys", state do
      random_row = Enum.random(state.data)

      for key <- Map.keys(random_row) do
        assert key in state.valid_keys
      end
    end

    test "all zip codes are San Francisco zip codes", state do
      bad_row_count =
        state.data
        |> Enum.find(&(String.to_integer(&1.zip_code) not in 94_101..94_188))

      assert bad_row_count == nil
    end
  end

  describe("find_carts_by_food_item/1") do
    # Test cases for the find_carts_by_zip_code/1 function in the FoodCarts context
    test "find_carts_by_food_item/1 without mention of dogs returns except rows" do
      carts = FoodCarts.find_carts_by_food_item("burger")
      burger_rows = Enum.find(carts, &(String.contains?(&1.food_items, "burger")))
      everything_except_dog_rows = Enum.find(carts, &(&1.food_items == "everything except for hot dogs"))

      assert Enum.count(burger_rows) > 0
      assert Enum.count(everything_except_dog_rows) > 0
    end

    test "find_carts_by_food_item/1 with mention of dogs does not return except rows" do
      carts = FoodCarts.find_carts_by_food_item("dogs")
      burger_rows = Enum.find(carts, &(String.contains?(&1.food_items, "dogs")))
      everything_except_dog_rows = Enum.find(carts, &(&1.food_items == "everything except for hot dogs"))

      assert Enum.count(burger_rows) > 0
      assert everything_except_dog_rows == nil
    end
  end

  describe("find_carts_by_zip_code/1") do
    # Test cases for the find_carts_by_food_item/1 function in the FoodCarts context
    test "find_carts_by_zip_code/1 returns records for zip_code 94111" do
      zip_carts =
        FoodCarts.find_carts_by_zip_code("94111")
        |> Enum.count()

      assert zip_carts > 0
    end
  end
end
