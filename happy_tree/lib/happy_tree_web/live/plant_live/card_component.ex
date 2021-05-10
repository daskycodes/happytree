defmodule HappyTreeWeb.PlantLive.CardComponent do
  use HappyTreeWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :action, nil)}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    ~L"""
      <div class="m-4 text-white bg-gray-700 rounded-lg shadow-md">
        <article class="flex flex-wrap items-center justify-between px-1">
          <div class='w-16 h-16 m-2 bg-green-500 rounded-lg shadow-md'> </div>
          <div class="m-2 md:w-40">
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
          <%= if @action != :show do %>
            <div class="flex items-center w-full h-12 m-2 text-center bg-green-500 rounded-lg shadow-md md:w-32">
              <span class="mx-auto"><%= live_redirect "Show Details", to: Routes.plant_show_path(@socket, :show, @plant) %></span>
            </div>
          <% end %>
        </article>
      </div>
    """
  end
end
