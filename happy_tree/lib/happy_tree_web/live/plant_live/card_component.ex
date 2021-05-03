defmodule HappyTreeWeb.PlantLive.CardComponent do
  use HappyTreeWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    ~L"""
      <div class="w-full h-20 m-4 text-white bg-gray-700 rounded-lg shadow-md">
        <article class="flex items-center justify-between px-1">
          <div class='w-16 h-16 m-2 bg-green-500 rounded-lg shadow-md'> </div>
          <div class="w-40 m-2">
            <p>Plant 🌱</p>
            <p class="font-bold"><%= HappyTree.Plants.Plant.device(@plant) %></p>
          </div>
          <div class="m-2">
            <p>Atmospheric Humidity 🌧</p>
            <p class="font-bold"><%= @metrics["hum"] %></p>
          </div>
          <div class="m-2">
            <p>Temperature 🌡</p>
            <p class="font-bold"><%= @metrics["temp"] %></p>
          </div>
          <div class="flex items-center w-32 h-12 m-2 text-center bg-green-500 rounded-lg shadow-md">
            <span class="mx-auto"><%= live_redirect "Show Details", to: Routes.plant_show_path(@socket, :show, @plant) %></span>
          </div>
        </article>
      </div>
    """
  end
end
