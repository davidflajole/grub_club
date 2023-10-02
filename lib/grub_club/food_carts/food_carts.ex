defmodule GrubClub.FoodCarts do

  @spec get_food_carts :: list
  def get_food_carts() do
    File.stream!("assets/MFFP.csv")
    |> CSV.decode(headers: true)
    |> Enum.to_list()
    |> Enum.map(&elem(&1, 1))
    |> Enum.filter(&(String.length(&1["Zip Codes"]) == 5))
    |> Enum.map(&Map.take(&1, ["Applicant", "Address", "FoodItems", "Latitude", "Longitude", "Zip Codes"]))
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
    |> CSV.decode
    |> Enum.to_list
    |> Enum.map(&elem(&1, 1))
    |> Enum.random
    |> hd()
  end

  def find_carts_by_zip_code(zip_code) do
    get_food_carts()
    |> Enum.filter(&(&1.zip_code === zip_code))
  end
end
