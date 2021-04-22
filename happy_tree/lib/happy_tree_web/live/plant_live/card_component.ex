defmodule HappyTreeWeb.PlantLive.CardComponent do
  use HappyTreeWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    current_temperature = assigns.plant.id
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div>@plant.common_name</div>
    <div>@current_temperature</div>
    """
  end
end
