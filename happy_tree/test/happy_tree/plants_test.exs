defmodule HappyTree.PlantsTest do
  use HappyTree.DataCase

  alias HappyTree.Plants

  describe "plants" do
    alias HappyTree.Plants.Plant

    @valid_attrs %{casual_name: "some casual_name", image_url: "some image_url", slug: "some slug"}
    @update_attrs %{casual_name: "some updated casual_name", image_url: "some updated image_url", slug: "some updated slug"}
    @invalid_attrs %{casual_name: nil, image_url: nil, slug: nil}

    def plant_fixture(attrs \\ %{}) do
      {:ok, plant} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Plants.create_plant()

      plant
    end

    test "list_plants/0 returns all plants" do
      plant = plant_fixture()
      assert Plants.list_plants() == [plant]
    end

    test "get_plant!/1 returns the plant with given id" do
      plant = plant_fixture()
      assert Plants.get_plant!(plant.id) == plant
    end

    test "create_plant/1 with valid data creates a plant" do
      assert {:ok, %Plant{} = plant} = Plants.create_plant(@valid_attrs)
      assert plant.casual_name == "some casual_name"
      assert plant.image_url == "some image_url"
      assert plant.slug == "some slug"
    end

    test "create_plant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Plants.create_plant(@invalid_attrs)
    end

    test "update_plant/2 with valid data updates the plant" do
      plant = plant_fixture()
      assert {:ok, %Plant{} = plant} = Plants.update_plant(plant, @update_attrs)
      assert plant.casual_name == "some updated casual_name"
      assert plant.image_url == "some updated image_url"
      assert plant.slug == "some updated slug"
    end

    test "update_plant/2 with invalid data returns error changeset" do
      plant = plant_fixture()
      assert {:error, %Ecto.Changeset{}} = Plants.update_plant(plant, @invalid_attrs)
      assert plant == Plants.get_plant!(plant.id)
    end

    test "delete_plant/1 deletes the plant" do
      plant = plant_fixture()
      assert {:ok, %Plant{}} = Plants.delete_plant(plant)
      assert_raise Ecto.NoResultsError, fn -> Plants.get_plant!(plant.id) end
    end

    test "change_plant/1 returns a plant changeset" do
      plant = plant_fixture()
      assert %Ecto.Changeset{} = Plants.change_plant(plant)
    end
  end
end
