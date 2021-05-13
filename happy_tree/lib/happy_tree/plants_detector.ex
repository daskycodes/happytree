defmodule HappyTree.PlantsDetector do
  def detect_plant(image) do
    with {:ok, %{"Labels" => labels}} <- detect_image_labels(image),
         labels when labels != [] <- filter_plant_labels(labels) do
      name = Map.get(List.first(labels), "Name")
      confidence = Map.get(List.first(labels), "Confidence")
      %{name: name, confidence: confidence}
    end
  end

  defp detect_image_labels(image) do
    ExAws.Rekognition.detect_labels(image, max_labels: 5, min_confidence: 80)
    |> ExAws.request(region: "eu-west-1")
  end

  defp filter_plant_labels(labels) do
    Enum.filter(labels, fn label ->
      parents = Map.fetch!(label, "Parents")
      (is_flower?(parents) or is_tree?(parents)) and not_petal?(label)
    end)
  end

  defp is_tree?(parents) do
    Enum.member?(parents, %{"Name" => "Tree"}) and
      Enum.member?(parents, %{"Name" => "Plant"})
  end

  defp is_flower?(parents) do
    Enum.member?(parents, %{"Name" => "Flower"}) and
      Enum.member?(parents, %{"Name" => "Plant"})
  end

  defp not_petal?(label) do
    Map.get(label, "Name") != "Petal"
  end
end
