defmodule HappyTree.Repo.Migrations.CreateGrowthTable do
  use Ecto.Migration

  def change do
    create table :growth do
      add :plant_id, references(:plants), null: false, on_delete: :delete_all
      add :atmospheric_humidity, :integer
      add :minimum_temperature, :integer
      add :maximum_temperature, :integer
      add :soil_humidity, :integer

      timestamps()
    end

    create unique_index(:growth, [:plant_id])
  end
end
