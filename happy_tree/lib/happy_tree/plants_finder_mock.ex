defmodule HappyTree.PlantsFinderMock do
  @moduledoc """
  This is the PlantsFinder module. It fakes the fetch request to the Trefle API
  """

  @doc """
  The find_plant function fakes the slug, common_name and growth data for the given plant name
  """
  @spec find_plant(binary) :: %{
          common_name: binary,
          growth: %{atmospheric_humidity: 4, soil_humidity: 4},
          slug: binary
        }
  def find_plant(name), do: plant_params_faker(name)

  defp plant_params_faker(name) do
    %{slug: slugify(name), common_name: name, growth: growth_faker()}
  end

  defp growth_faker(), do: %{atmospheric_humidity: 4, soil_humidity: 4}

  defp slugify(name) do
    name
    |> String.downcase()
    |> String.split()
    |> Enum.join()
  end
end
