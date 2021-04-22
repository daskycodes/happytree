defmodule HappyTree.DeviceTracker do
  use GenServer

  defmodule State do
    defstruct device: nil, temperature: nil
  end

  def start_link(device) do
    GenServer.start_link(__MODULE__, device, name: :"#{__MODULE__}-#{device}")
  end

  def update_metrics(:temperature, device, temperature) do
    GenServer.call(:"#{__MODULE__}-#{device}", {:update_temperature, temperature})
  end

  def init(device) do
    {:ok, %State{device: device}}
  end

  def handle_call({:update_temperature, temperature}, _from, state) do
    broadcast({:ok, state.device, state.temperature}, :updated_temperature)
    {:reply, :ok, %{state | temperature: temperature}}
  end

  def subscribe(), do: Phoenix.PubSub.subscribe(HappyTree.PubSub, "metrics")

  def broadcast({:error, _reason} = error), do: error

  def broadcast({:ok, device, metrics}, event) do
    Phoenix.PubSub.broadcast(HappyTree.PubSub, "metrics", {event, device, metrics})
    {:ok, metrics}
  end
end
