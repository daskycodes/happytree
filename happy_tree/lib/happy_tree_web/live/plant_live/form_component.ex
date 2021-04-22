defmodule HappyTreeWeb.PlantLive.FormComponent do
  use HappyTreeWeb, :live_component

  alias HappyTree.Plants

  @impl true
  def update(%{plant: plant} = assigns, socket) do
    changeset = Plants.change_plant(plant)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:plant_name, "")}
  end

  @impl true
  def handle_event("validate", %{"plant" => plant_params}, socket) do
    changeset =
      socket.assigns.plant
      |> Plants.change_plant(plant_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  # TODO Handle growth params
  @impl true
  def handle_event("snap", %{"dataUri" => "data:image/jpeg;base64," <> base64frame}, socket) do
    image = Base.decode64!(base64frame)
    plant_name = HappyTree.PlantsDetector.detect_plant(image)
    plant_params = HappyTree.PlantsDetector.find_plant(plant_name)
    save_plant(socket, :new, plant_params)
    {:noreply, assign(socket, :plant_name, plant_name)}
  end

  def handle_event("save", %{"plant" => plant_params}, socket) do
    save_plant(socket, socket.assigns.action, plant_params)
  end

  defp save_plant(socket, :edit, plant_params) do
    case Plants.update_plant(socket.assigns.plant, plant_params) do
      {:ok, _plant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Plant updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_plant(socket, :new, plant_params) do
    case Plants.create_plant(plant_params) do
      {:ok, _plant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Plant created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
