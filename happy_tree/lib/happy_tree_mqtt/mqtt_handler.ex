defmodule HappyTreeMqtt.MqttHandler do
  use Tortoise.Handler

  require Logger

  def init(_opts) do
    Logger.info("Initializing handler")
    {:ok, %{}}
  end

  def handle_message(["plants", device, "data"], payload, state) do
    %{device_trackers: device_trackers} = HappyTreeMqtt.DeviceServer.list_device_trackers()

    case Map.fetch(device_trackers, device) do
      {:ok, {_pid, _ref}} -> HappyTreeMqtt.DeviceTracker.update_data(device, payload)
      :error -> Logger.error("Payload #{payload} sent to untracked device #{device}")
    end

    {:ok, state}
  end

  def connection(:up, state) do
    Logger.info("Connection has been established")
    {:ok, state}
  end

  def connection(:down, state) do
    Logger.warn("Connection has been dropped")
    {:ok, state}
  end

  def connection(:terminating, state) do
    Logger.warn("Connection is terminating")
    {:ok, state}
  end

  def subscription(:up, topic, state) do
    Logger.info("Subscribed to #{topic}")
    {:ok, state}
  end

  def subscription({:warn, [requested: req, accepted: qos]}, topic, state) do
    Logger.warn("Subscribed to #{topic}; requested #{req} but got accepted with QoS #{qos}")
    {:ok, state}
  end

  def subscription({:error, reason}, topic, state) do
    Logger.error("Error subscribing to #{topic}; #{inspect(reason)}")
    {:ok, state}
  end

  def subscription(:down, topic, state) do
    Logger.info("Unsubscribed from #{topic}")
    {:ok, state}
  end
end
