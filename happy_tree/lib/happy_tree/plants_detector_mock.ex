defmodule HappyTree.PlantsDetectorMock do
  def detect_plant(_image) do
    %{name: "sunflower", confidence: 90}
  end
end
