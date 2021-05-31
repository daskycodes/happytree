defmodule HappyTreeWeb.PlantLive.CardComponent do
  use HappyTreeWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :action, nil)}
  end

  @impl true
  def update(assigns, socket) do
    metrics = HappyTreeMqtt.DeviceTracker.read_data(assigns.id)
    assigns = Map.put(assigns, :metrics, metrics)
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    ~L"""
      <div class="m-4 text-white bg-gray-700 rounded-lg shadow-md <%= if @plant.__meta__.state == :deleted do %>hidden <% end %>">
        <article class="flex flex-wrap items-center justify-between px-1">
          <div class='w-16 h-16 m-2 <%= if device_offline?(@metrics) do %> bg-gray-300 <% else %> <%= status_color(@metrics) %> <% end %> rounded-lg shadow-md'> </div>
          <div class="m-2 md:w-40">
            <p>Plant 🌱</p>
            <p class="font-bold"><%= HappyTree.Plants.Plant.device(@plant) %></p>
          </div>
          <div class="m-2">
            <p>Atmospheric Humidity 🌧</p>
            <p class="font-bold"><%= @metrics["hum"] %>% <%= status_emoji(@metrics["hum_status"]) %></p>
          </div>
          <div class="m-2">
            <p>Temperature 🌡</p>
            <p class="font-bold"><%= @metrics["temp"] %>°C <%= status_emoji(@metrics["temp_status"]) %></p>
          </div>
          <%= if @action != :show do %>
            <div class="flex items-center w-full h-12 m-2 text-center bg-green-500 rounded-lg shadow-md lg:w-32">
              <span class="mx-auto"><%= live_redirect "Show Details", to: Routes.plant_show_path(@socket, :show, @plant) %></span>
            </div>
          <% end %>
        </article>
      </div>
    """
  end

  defp device_offline?(metrics) do
    case Map.fetch(metrics, "last_reading") do
      {:ok, time} -> NaiveDateTime.diff(NaiveDateTime.utc_now(), time) > 30
      :error -> true
    end
  end

  defp status_emoji(:out_of_range), do: "🙁"
  defp status_emoji(:in_range), do: "🙂"
  defp status_emoji(_), do: ""

  defp status_color(%{"hum_status" => :in_range, "temp_status" => :in_range}), do: "bg-green-500"
  defp status_color(_), do: "bg-red-500"
end
