defmodule NxPerceptron do
  @moduledoc """
  Documentation for `NxPerceptron`.
  """

  defstruct [:learning_rate, :epochs, :inputs, :weights]

  @type t() :: %NxPerceptron{
          learning_rate: float(),
          epochs: integer(),
          inputs: Nx.Tensor.t(),
          weights: Nx.Tensor.t()
        }

  @epochs 100

  @spec new() :: NxPercepton.t()
  def new() do
    %NxPerceptron{
      learning_rate: 0.3,
      epochs: 0,
      inputs: Nx.tensor([[1, 0, 0], [1, 0, 1], [1, 1, 0], [1, 1, 1]]),
      weights: Nx.tensor([1, 1, 1])
    }
  end

  @doc """
  Trains a basic perceptron neural network

  ## Examples

      iex> perceptron = NxPerceptron.new()
      iex> logical_and = Nx.tensor([0, 0, 0, 1])
      iex> perceptron = NxPerceptron.train(perceptron, logical_and)
      iex> perceptron.weights
      #Nx.Tensor<
        f32[3]
        [-0.8000001311302185, 0.699999988079071, 0.699999988079071]
      >
  """
  @spec train(NxPerceptron.t(), Nx.Tensor.t()) :: NxPerceptron.t()
  def train(perceptron, expected)

  def train(%NxPerceptron{epochs: epochs} = perceptron, expected) when epochs < @epochs do
    new_weights =
      expected
      |> Nx.subtract(evaluate(perceptron))
      |> Nx.multiply(perceptron.learning_rate)
      |> Nx.dot(perceptron.inputs)
      |> Nx.add(perceptron.weights)

    perceptron = %{perceptron | epochs: epochs + 1, weights: new_weights}

    train(perceptron, expected)
  end

  def train(%NxPerceptron{} = perceptron, _), do: perceptron

  @doc """
  Evaluates a NxPerceptron struct

  ## Examples

      iex> perceptron = NxPerceptron.new()
      iex> logical_and = Nx.tensor([0, 0, 0, 1])
      iex> NxPerceptron.train(perceptron, logical_and) |> NxPerceptron.evaluate()
      #Nx.Tensor<
        u8[4]
        [0, 0, 0, 1]
      >
  """
  @spec evaluate(NxPerceptron.t()) :: Nx.Tensor.t()
  def evaluate(%NxPerceptron{weights: weights, inputs: inputs}),
    do: Nx.dot(inputs, weights) |> Nx.greater(0)
end
