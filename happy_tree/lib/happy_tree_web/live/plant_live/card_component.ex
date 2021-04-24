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
      <tr id="plant-<%= @plant.id %>">
        <td><%= @plant.common_name %></td>
        <td><%= @plant.slug %></td>
        <td><%= @plant.image_url %></td>
        <td><%= Jason.encode!(@metrics) %></td>

        <td>
          <span><%= live_redirect "Show", to: Routes.plant_show_path(@socket, :show, @plant) %></span>
          <span><%= live_patch "Edit", to: Routes.plant_index_path(@socket, :edit, @plant) %></span>
          <span><%= link "Delete", to: "#", phx_click: "delete", phx_value_id: @plant.id, data: [confirm: "Are you sure?"] %></span>
        </td>
      </tr>
    """
  end
end
