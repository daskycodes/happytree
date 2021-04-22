defmodule HappyTree.Plants.Plant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plants" do
    field :common_name, :string
    field :image_url, :string
    field :slug, :string
    field :device, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(plant, attrs) do
    plant
    |> cast(attrs, [:common_name, :slug, :image_url])
    |> validate_required([:common_name, :slug])
  end
end
