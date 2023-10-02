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

    test "all zip codes are San Francisco zip codes", state do
      bad_row_count =
        state.data
        |> Enum.find(&(String.to_integer(&1.zip_code) not in 94101..94188 ))

        assert bad_row_count == nil
    end
  end

  describe("find_carts_by_zip_code/1") do
    # Test cases for the find_carts_by_zip_code/1 function in the FoodCarts context
    test "find_carts_by_zip_code/1 returns records for zip_code 94111" do
      zip_carts =
        FoodCarts.find_carts_by_zip_code("94111")
        |> Enum.count

        assert zip_carts > 0
    end
  end
end
