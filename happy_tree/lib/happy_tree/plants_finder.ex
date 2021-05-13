defmodule HappyTree.PlantsFinder do
  @moduledoc """
  This is the PlantsFinder module. It communicates with the Trefle API.
  """

  @doc """
  The find_plant function fetches the slug, common_name and growth data for the given plant name
  """
  @spec find_plant(binary) ::
          {:error, non_neg_integer, %{}}
          | %{common_name: any, growth: any, slug: binary | non_neg_integer}
  def find_plant(name) do
    with {:ok, result} <- Trifolium.Plants.search(name),
         slug <- List.first(result["data"]) |> Map.get("slug"),
         {:ok, plant} <- Trifolium.Plants.find(slug) do
      growth = get_in(plant, ["data", "main_species", "growth"])
      %{slug: slug, common_name: plant["data"]["common_name"], growth: growth}
    end
  end
end
