defmodule HappyTreeMqtt.DeviceServer do
  use GenServer

  require Logger

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
    {:ok, %{}}
  end

  def handle_cast({:start_tracking, plant}, state) do
    device = HappyTree.Plants.Plant.device(plant)
    Logger.info("Starting to track #{device} metrics")
    start_device_tracker(%{device: device, plant: plant})
    {:noreply, state}
  end

  def handle_call(:list_device_trackers, _from, state) do
    match_all = {:"$1", :"$2", :_}
    map_result = [%{device: :"$1", pid: :"$2"}]
    result = Registry.select(HappyTree.DeviceRegistry, [{match_all, [], map_result}])
    {:reply, result, state}
  end

  def handle_call({:stop_tracking, device}, _from, state) do
    HappyTreeMqtt.DeviceTracker.stop(device)
    Logger.info("Stopped to track #{device} metrics")
    {:reply, :ok, state}
  end

  def handle_info({:DOWN, _ref, :process, _pid, :normal}, state) do
    {:noreply, state}
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
