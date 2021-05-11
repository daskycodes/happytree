defmodule HappyTreeMqtt.DeviceTracker do
  use GenServer

  defmodule State do
    defstruct device: nil, data: %{}, plant: nil
  end

  # Client Callbacks

  def start_link(%{device: device, plant: _plant} = args) do
    GenServer.start_link(__MODULE__, args, name: :"#{__MODULE__}-#{device}")
  end

  def update_data(device, data) do
    GenServer.call(:"#{__MODULE__}-#{device}", {:update_data, data})
  end

  def read_data(device) do
    GenServer.call(:"#{__MODULE__}-#{device}", :read_data)
  end

  def subscribe(), do: Phoenix.PubSub.subscribe(HappyTree.PubSub, "metrics")

  def broadcast({:error, _reason} = error), do: error

  def broadcast({:ok, device, data}, event) do
    Phoenix.PubSub.broadcast(HappyTree.PubSub, "metrics", {event, device, data})
    {:ok, data}
  end

  # Server Callbacks

  def init(%{device: device, plant: plant}) do
    {:ok, %State{device: device, data: %{}, plant: plant}}
  end

  def handle_call({:update_data, data}, _from, state) do
    data = Jason.decode!(data) |> Map.put("last_reading", NaiveDateTime.utc_now())
    HappyTreeMqtt.PlantChecker.check(state, data)
    broadcast({:ok, state.device, data}, :data_updated)
    {:reply, :ok, %{state | data: data}}
  end

  def handle_call(:read_data, _from, state) do
    {:reply, state.data, state}
  end
end
