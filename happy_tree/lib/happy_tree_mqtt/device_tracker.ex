defmodule HappyTreeMqtt.DeviceTracker do
  use GenServer, restart: :transient

  defmodule State do
    defstruct device: nil, data: %{}, plant: nil
  end

  # Client Callbacks

  def start_link(%{device: device, plant: _plant} = args) do
    GenServer.start_link(__MODULE__, args, name: via(device))
  end

  def update_data(device, data) do
    GenServer.call(device_pid(device), {:update_data, data})
  end

  def read_data(device) do
    GenServer.call(device_pid(device), :read_data)
  end

  def update_plant({:ok, plant}) do
    device = HappyTree.Plants.Plant.device(plant)
    GenServer.call(device_pid(device), {:update_plant, plant})
  end

  def stop(device) do
    GenServer.stop(device_pid(device))
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
    data = Map.merge(data, HappyTreeMqtt.PlantChecker.check(state, data))
    broadcast({:ok, state.device, data}, :data_updated)
    {:reply, :ok, %{state | data: data}}
  end

  def handle_call(:read_data, _from, state) do
    {:reply, state.data, state}
  end

  def handle_call({:update_plant, plant}, state) do
    state = %{state | plant: plant}
    {:reply, {:ok, plant}, state}
  end

  # Private Function

  defp via(key) do
    {:via, Registry, {HappyTree.DeviceRegistry, key}}
  end

  defp device_pid(device) do
    [{pid, _value}] = Registry.lookup(HappyTree.DeviceRegistry, device)
    pid
  end
end
