defmodule Learning do
  @spec model :: Axon.t()
  def model do
    Axon.input({nil, 2}) |> Axon.dense(2, activation: :hard_sigmoid)
  end

  def inputs do
    Nx.tensor([
      [0, 0],
      [0, 1],
      [1, 0],
      [1, 1]
    ])
  end

  def expected_outputs do
    Nx.tensor([
      [0, 0],
      [0, 1],
      [0, 1],
      [1, 1]
    ])
  end

  def train do
    model()
    |> Axon.Training.step(:mean_squared_error, Axon.Optimizers.sgd(0.8))
    |> Axon.Training.train([inputs()], [expected_outputs()], epochs: 10000)
  end
end
