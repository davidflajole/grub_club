defmodule GrubClub.FoodCarts do
  def get_food_carts() do
    File.stream!("assets/MFFP.csv")
    |> CSV.decode(headers: true)
    |> Enum.to_list
    |> Enum.map(&elem(&1,1))
    |> Enum.filter(&String.length(&1["Zip Codes"]) == 5)
    |> Enum.map(&(Map.take(&1, ["Applicant", "Address", "Latitude", "Longitude", "Zip Codes"])))
    |> Enum.map(&(Map.new(&1, fn x -> {String.downcase(elem(x, 0)), elem(x, 1)} end)))
    |> Enum.map(&(Map.new(&1, fn x -> {String.replace(elem(x, 0), " ", "_"), elem(x, 1)} end)))
    |> Enum.map(&(Map.new(&1, fn x -> {String.to_atom(elem(x, 0)), elem(x, 1)} end)))
  end
end
