defmodule HappyTree.Config do
  def plants_detector() do
    Application.fetch_env!(:happy_tree, :plants_detector)
    |> Keyword.fetch!(:module)
  end

  def plants_finder() do
    Application.fetch_env!(:happy_tree, :plants_finder)
    |> Keyword.fetch!(:module)
  end
end
