defmodule GrubClub.FoodCartsTest do
  use ExUnit.Case

  alias GrubClub.FoodCarts

  setup_all do
    {:ok, data: FoodCarts.get_food_carts}
  end

  describe("get_food_carts/0") do
    # Test cases for the get_food_carts/0 function in the FoodCarts context
    test "get_food_carts/0 returns only data from 292 filtered records", state do
      assert Enum.count(state.data) == 292
    end

    test "get_food_carts/0 returns only data from chosen keys", state do
      random_row = Enum.random(state.data)

      for key <- Map.keys(random_row) do
        assert key in [:address, :applicant, :latitude, :longitude, :zip_code]
      end
    end

    test "all zip codes are 5 characters long", state do
      zip_row_count =
        state.data
        |> Enum.filter(&String.length(&1.zip_code) != 5)
        |> Enum.count

        assert zip_row_count == 0
    end
  end

end
