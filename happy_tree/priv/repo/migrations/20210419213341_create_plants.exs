defmodule HappyTree.Repo.Migrations.CreatePlants do
  use Ecto.Migration

  def change do
    create table(:plants) do
      add :common_name, :string
      add :slug, :string
      add :image_url, :string

      timestamps()
    end

  end
end
