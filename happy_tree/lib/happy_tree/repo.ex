defmodule HappyTree.Repo do
  use Ecto.Repo,
    otp_app: :happy_tree,
    adapter: Ecto.Adapters.Postgres
end
