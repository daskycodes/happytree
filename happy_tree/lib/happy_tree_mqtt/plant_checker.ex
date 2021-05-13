defmodule HappyTreeMqtt.PlantChecker do
  def check(state, data) do
    check_status(:atmospheric_humidity, state, data)
    check_status(:temperature, state, data)
  end

  def check_status(:atmospheric_humidity, state, data) do
    current_atmospheric_humidity = data["hum"]
    optimal = state.plant.growth.atmospheric_humidity

    unless is_nil(optimal) do
      range = (optimal * 10 - 10)..(optimal * 10 + 10)

      case Enum.member?(range, current_atmospheric_humidity) do
        true ->
          Tortoise.publish("tortoise", "plants/#{state.device}/atmospheric_humidity_in_range")

        false ->
          Tortoise.publish("tortoise", "plants/#{state.device}/atmospheric_humidity_out_of_range")
      end
    end
  end

  def check_status(:temperature, state, data) do
    temp = data["temp"]
    min_temp = state.plant.growth.minimum_temperature
    max_temp = state.plant.growth.maximum_temperature

    range = min_temp..max_temp

    case Enum.member?(range, temp) do
      true ->
        Tortoise.publish("tortoise", "plants/#{state.device}/temperature_in_range")

      false ->
        Tortoise.publish("tortoise", "plants/#{state.device}/temperature_out_of_range")
    end
  end
end
