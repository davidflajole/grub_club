defmodule GrubClub.FoodCarts do
  def get_food_carts() do
    string_key_maps =
      File.stream!("assets/MFFP.csv")
      |> CSV.decode(headers: true)
      |> Enum.to_list
      |> Enum.map(&elem(&1,1))
      |> Enum.filter(&String.length(&1["Zip Codes"]) == 5)
      |> Enum.map(&(Map.take(&1, ["Applicant", "Address", "Location", "Zip Codes"])))
      |> Enum.map()

      # |> Map.new(fn {k, v} -> {String.downcase(k), v} end)
      # |> Map.new(fn {k, v} -> {String.replace(k, " ", "_"), v} end)
      # |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

      string_key_maps

    # for {key, val} <- string_key_map, into: %{}, do: {String.to_atom(key), val}
  end
end
