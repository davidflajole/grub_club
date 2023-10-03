defmodule GrubClub.FoodCarts do
  @moduledoc """
  FoodCarts context file
  """

  @spec get_food_carts :: list
  def get_food_carts() do
    File.stream!("assets/MFFP.csv")
    |> CSV.decode(headers: true)
    |> Enum.to_list()
    |> Enum.map(&elem(&1, 1))
    |> Enum.filter(&(String.length(&1["Zip Codes"]) == 5))
    |> Enum.map(
      &Map.take(&1, ["Applicant", "Address", "FoodItems", "Latitude", "Longitude", "Zip Codes"])
    )
    |> Enum.map(&Map.new(&1, fn x -> {String.downcase(elem(x, 0)), elem(x, 1)} end))
    |> Enum.map(&Map.new(&1, fn x -> {String.replace(elem(x, 0), " ", "_"), elem(x, 1)} end))
    |> Enum.map(
      &Map.new(&1, fn x -> {String.replace(elem(x, 0), "zip_codes", "zip_code"), elem(x, 1)} end)
    )
    |> Enum.map(
      &Map.new([
        {:applicant, &1["applicant"]},
        {:food_items, &1["fooditems"]},
        {:address, &1["address"]},
        {:latitude, &1["latitude"]},
        {:longitude, &1["longitude"]},
        {:zip_code, mock_geo_sf_zip()}
      ])
    )
  end

  def mock_geo_sf_zip() do
    File.stream!("assets/SanFranZips.csv")
    |> CSV.decode()
    |> Enum.to_list()
    |> Enum.map(&elem(&1, 1))
    |> Enum.random()
    |> hd()
  end

  def find_carts_by_zip_code(zip_code) do
    get_food_carts()
    |> Enum.filter(&(&1.zip_code === zip_code))
  end

  def find_carts_by_name(name) do
    get_food_carts()
    |> Enum.filter(&string_in_field?(&1.applicant, name))
  end

  def find_carts_by_food_item(food_item) do
    if string_in_field?(food_item, "dogs") do
      find_dog_carts(food_item)
    else
      find_non_dog_carts(food_item)
    end
  end

  defp find_dog_carts(food_item) do
    get_food_carts()
    |> Enum.filter(
      &(string_in_field?(&1.food_items, food_item) and
          &1.food_items !== "everything except for hot dogs")
    )
  end

  defp find_non_dog_carts(food_item) do
    get_food_carts()
    |> Enum.filter(
      &(string_in_field?(&1.food_items, food_item) or
          &1.food_items === "everything except for hot dogs")
    )
  end

  defp string_in_field?(field, value_string) do
    field = String.downcase(field)
    value_string = String.downcase(value_string)

    String.contains?(field, value_string)
  end
end
