defmodule HappyTree.Plants.Growth do
  use Ecto.Schema
  import Ecto.Changeset

  schema "growth" do
    field :atmospheric_humidity, :integer
    field :minimum_temperature, :map
    field :maximum_temperature, :map
    field :soil_humidity, :integer

    belongs_to :plant, HappyTree.Plants.Plant

    timestamps()
  end

  @doc false
  def changeset(growth, attrs) do
    growth
    |> cast(attrs, [
      :atmospheric_humidity,
      :minimum_temperature,
      :maximum_temperature,
      :soil_humidity
    ])
  end
end
