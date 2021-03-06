defmodule HappyTreeWeb.PlantLive.FormComponent do
  use HappyTreeWeb, :live_component

  alias HappyTree.Plants

  @plants_finder HappyTree.Config.plants_finder()
  @plants_detector HappyTree.Config.plants_detector()

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

  @impl true
  def handle_event("snap", %{"dataUri" => "data:image/jpeg;base64," <> base64frame}, socket) do
    image = Base.decode64!(base64frame)

    with %{name: plant_name, confidence: confidence} when is_binary(plant_name) <-
           @plants_detector.detect_plant(image),
         plant_params <- @plants_finder.find_plant(plant_name) do
      save_plant(socket, :new, plant_params |> Map.put(:confidence, confidence))
    else
      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "Could not recognize a Plant, try again")
         |> push_redirect(to: socket.assigns.return_to)}
    end
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
      {:ok, plant} ->
        HappyTreeMqtt.DeviceServer.start_tracking(plant)

        {:noreply,
         socket
         |> put_flash(:info, success_save_message(plant_params))
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp success_save_message(plant_params) do
    "Added #{plant_params.common_name} with #{plant_params.confidence}% Confidence"
  end
end
