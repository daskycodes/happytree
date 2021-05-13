defmodule HappyTreeMqtt.DeviceServer do
  use GenServer

  require Logger

  defmodule State do
    defstruct device_trackers: %{}
  end

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_tracking(plant) do
    GenServer.cast(__MODULE__, {:start_tracking, plant})
  end

  def stop_tracking(plant) do
    GenServer.call(__MODULE__, {:stop_tracking, plant})
  end

  def list_device_trackers() do
    GenServer.call(__MODULE__, :list_device_trackers)
  end

  def init(_args) do
    Enum.each(HappyTree.Plants.list_plants(), &start_tracking/1)
    {:ok, %State{}}
  end

  def handle_cast({:start_tracking, plant}, state) do
    device = HappyTree.Plants.Plant.device(plant)
    Logger.info("Starting to track #{device} metrics")
    result = start_device_tracker(%{device: device, plant: plant})
    device_trackers = Map.put(state.device_trackers, device, result)
    {:noreply, %{state | device_trackers: device_trackers}}
  end

  def handle_call(:list_device_trackers, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:stop_tracking, device}, _from, state) do
    state.device_trackers
    |> Map.get(device)
    |> elem(0)
    |> Process.exit(:normal)

    Logger.info("Stopped to track #{device} metrics")

    {:reply, :ok, state}
  end

  defp start_device_tracker(device) do
    {:ok, pid} =
      DynamicSupervisor.start_child(
        HappyTree.DynamicSupervisor,
        {HappyTreeMqtt.DeviceTracker, device}
      )

    ref = Process.monitor(pid)

    {pid, ref}
  end
end
