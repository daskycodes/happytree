defmodule HappyTreeWeb.PlantLive.Show do
  use HappyTreeWeb, :live_view

  alias HappyTree.Plants

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: HappyTreeMqtt.DeviceTracker.subscribe()

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:plant, Plants.get_plant!(id))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    plant = Plants.get_plant!(id)
    {:ok, _} = Plants.delete_plant(plant)
    device = HappyTree.Plants.Plant.device(plant)
    HappyTreeMqtt.DeviceServer.stop_tracking(device)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:data_updated, device, metrics}, socket) do
    send_update(HappyTreeWeb.PlantLive.CardComponent, id: device, metrics: metrics)
    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Plant"
  defp page_title(:edit), do: "Edit Plant"
end
