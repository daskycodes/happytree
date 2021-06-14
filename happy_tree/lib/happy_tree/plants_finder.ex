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
    with {:ok, %{"data" => [%{"slug" => slug} | _]}} <- Trifolium.Plants.search(name),
         {:ok, plant} <- Trifolium.Plants.find(slug) do
      growth = plant["main_species"]["growth"]
      %{slug: slug, common_name: plant["common_name"], growth: growth}
    end
  end
end
