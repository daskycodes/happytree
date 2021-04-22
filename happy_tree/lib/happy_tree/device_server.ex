defmodule HappyTree.DeviceServer do
  use GenServer

  require Logger

  defmodule State do
    defstruct device_trackers: %{}
  end

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_tracking(device) do
    GenServer.cast(__MODULE__, {:start_tracking, device})
  end

  def init(_args) do
    {:ok, %State{}}
  end

  def handle_cast({:start_tracking, device}, state) do
    Logger.info("Starting to track #{device} metrics")
    result = start_device_tracker(device)
    device_trackers = Map.put(state.device_trackers, device, result)
    {:noreply, %{state | device_trackers: device_trackers}}
  end

  defp start_device_tracker(device) do
    {:ok, pid} =
      DynamicSupervisor.start_child(
        HappyTree.DynamicSupervisor,
        {HappyTree.DeviceTracker, device}
      )

    ref = Process.monitor(pid)

    {pid, ref}
  end
end
