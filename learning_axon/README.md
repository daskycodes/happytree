# NxPerceptron

A basic perceptron neural network using [Nx](https://github.com/elixir-nx/nx/tree/main/nx)

## Installation

- [Install elixir](https://elixir-lang.org/install.html)
- Run `mix deps.get`

## Usage

- Run `iex -S mix` to start an interactive elixir repl

Train a basic perceptron neural network

```elixir
iex> perceptron = NxPerceptron.new()
iex> logical_and = Nx.tensor([0, 0, 0, 1])
iex> perceptron = NxPerceptron.train(perceptron, logical_and)
iex> perceptron.weights
#Nx.Tensor<
  f32[3]
  [-0.8000001311302185, 0.699999988079071, 0.699999988079071]
>
```

Evaluate a `NxPerceptron` struct

```elixir
iex> perceptron = NxPerceptron.new()
iex> logical_and = Nx.tensor([0, 0, 0, 1])
iex> NxPerceptron.train(perceptron, logical_and) |> NxPerceptron.evaluate()
#Nx.Tensor<
  u8[4]
  [0, 0, 0, 1]
>
```

## Links

- [Introducing Nx - José Valim | Lambda Days 2021](https://www.youtube.com/watch?v=fPKMmJpAGWc)
- [Perceptron - Wikipedia](https://en.wikipedia.org/wiki/Perceptron)
- [Frank Rosenblatt](https://en.wikipedia.org/wiki/Frank_Rosenblatt)
