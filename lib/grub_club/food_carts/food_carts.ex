defmodule GrubClub.FoodCarts do
  @moduledoc """
  FoodCarts context file
  """


  @doc """
  Gets a list of food carts from the source csv file

  Returns a list of maps

  ## Examples

      iex> GrubClub.FoodCarts.get_food_carts
      [
        {
          address: "1 SANSOME ST",
          zip_code: "94172",
          food_items: "Tacos: burritos: quesadillas: soda & water",
          applicant: "Tacos Rodriguez",
          latitude: "37.790485146128",
          longitude: "-122.40094044068951"
        }...
      ]

  """
  @spec get_food_carts :: list
  def get_food_carts() do
    File.stream!("assets/MFFP.csv")
    |> CSV.decode(headers: true)
    |> Enum.to_list()
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&Map.take(&1, ["Applicant", "Address", "FoodItems", "Latitude", "Longitude"]))
    |> Enum.map(&Map.new(&1, fn x -> {String.downcase(elem(x, 0)), elem(x, 1)} end))
    |> Enum.map(&Map.new(&1, fn x -> {String.replace(elem(x, 0), " ", "_"), elem(x, 1)} end))
    |> Enum.map(&Map.new(&1, fn x -> {String.replace(elem(x, 0), "fooditems", "food_items"), elem(x, 1)} end))
    |> Enum.map(&Map.new(&1, fn {k, v} -> {String.to_atom(k), v} end))
    |> Enum.map(&Map.put(&1, :zip_code, mock_geo_sf_zip()))
  end

  @doc """
  Mocks out a San Francisco zip code

  Returns a string

  ## Examples

      iex> GrubClub.FoodCarts.mock_geo_sf_zip
      "94111"

  """
  @spec mock_geo_sf_zip :: any
  def mock_geo_sf_zip() do
    File.stream!("assets/SanFranZips.csv")
    |> CSV.decode()
    |> Enum.to_list()
    |> Enum.map(&elem(&1, 1))
    |> Enum.random()
    |> hd()
  end

  @doc """
  Finds carts by a given San Francisco zip code

  Returns a list of carts

  ## Examples

      iex> GrubClub.FoodCarts.find_carts_by_zip_code("94111")
      [
        %{
          address: "400 CALIFORNIA ST",
          zip_code: "94111",
          food_items: "Daily rotating menus consisting of various local & organic vegetable: poultry: meat: seafood : rice & bread dishes.",
          applicant: "Munch India",
          latitude: "37.79330427556103",
          longitude: "-122.4014589984134"
        }...
      ]

  """
  @spec find_carts_by_zip_code(any) :: list
  def find_carts_by_zip_code(zip_code) do
    get_food_carts()
    |> Enum.filter(&(&1.zip_code === zip_code))
  end

  @doc """
  Finds carts by a portion of the applicants businesss name

  Returns a list of carts

  ## Examples

      iex> GrubClub.FoodCarts.find_carts_by_name("Mini Mobile")
      [
        %{
          address: "147 FREMONT ST",
          zip_code: "94157",
          food_items: "Cold Truck: Corn Dogs: Noodle Soups: Candy: Pre-packaged Snacks: Sandwiches: Chips: Coffee: Tea: Various Beverages",
          applicant: "Mini Mobile Food Catering",
          latitude: "37.79018557063344",
          longitude: "-122.39547172580944"
        }...
      ]

  """
  @spec find_carts_by_name(any) :: list()
  def find_carts_by_name(name) do
    get_food_carts()
    |> Enum.filter(&string_in_field?(&1.applicant, name))
  end

  @doc """
  Finds carts by a word sequence in the food items field

  Returns a list of carts

  ## Examples

      iex> GrubClub.FoodCarts.find_carts_by_food_item("Noodle Soups")
      [
        %{
          address: "147 FREMONT ST",
          zip_code: "94157",
          food_items: "Cold Truck: Corn Dogs: Noodle Soups: Candy: Pre-packaged Snacks: Sandwiches: Chips: Coffee: Tea: Various Beverages",
          applicant: "Mini Mobile Food Catering",
          latitude: "37.79018557063344",
          longitude: "-122.39547172580944"
        }...
      ]

  """
  @spec find_carts_by_food_item(binary) :: list
  def find_carts_by_food_item(food_item) do
    if string_in_field?(food_item, "dogs") do
      find_dog_carts(food_item)
    else
      find_non_dog_carts(food_item)
    end
  end

  @spec find_dog_carts(binary) :: list
  defp find_dog_carts(food_item) do
    get_food_carts()
    |> Enum.filter(
      &(string_in_field?(&1.food_items, food_item) and
          &1.food_items !== "everything except for hot dogs")
    )
  end

  @spec find_non_dog_carts(binary) :: list
  defp find_non_dog_carts(food_item) do
    get_food_carts()
    |> Enum.filter(
      &(string_in_field?(&1.food_items, food_item) or
          &1.food_items === "everything except for hot dogs")
    )
  end

  @spec string_in_field?(binary, binary) :: boolean
  defp string_in_field?(field, value_string) do
    field = String.downcase(field)
    value_string = String.downcase(value_string)

    String.contains?(field, value_string)
  end
end
