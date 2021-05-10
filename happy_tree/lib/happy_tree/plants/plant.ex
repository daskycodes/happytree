defmodule HappyTree.Plants.Plant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plants" do
    field :common_name, :string
    field :image_url, :string
    field :slug, :string

    has_one :growth, HappyTree.Plants.Growth, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(plant, attrs) do
    plant
    |> cast(attrs, [:common_name, :slug, :image_url])
    |> validate_required([:common_name, :slug])
    |> cast_assoc(:growth)
  end

  def device(%__MODULE__{} = plant) do
    "#{plant.slug}#{plant.id}"
  end
end
