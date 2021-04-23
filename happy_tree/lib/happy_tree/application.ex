defmodule HappyTree.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      HappyTree.Repo,
      # Start the Telemetry supervisor
      HappyTreeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: HappyTree.PubSub},
      # Start the Endpoint (http/https)
      HappyTreeWeb.Endpoint,
      {
        DynamicSupervisor,
        strategy: :one_for_one, name: HappyTree.DynamicSupervisor
      },
      {HappyTree.DeviceServer, []}
      # Start a worker by calling: HappyTree.Worker.start_link(arg)
      # {HappyTree.Worker, arg}
    ]

    Tortoise.Supervisor.start_child(
      client_id: "tortoise",
      handler: {HappyTree.MqttHandler, []},
      server: {
        Tortoise.Transport.SSL,
        host: Application.fetch_env!(:ex_aws, :iot_host) |> to_charlist,
        port: 8883,
        keyfile: Application.fetch_env!(:ex_aws, :iot_keyfile) |> to_charlist,
        certfile: Application.fetch_env!(:ex_aws, :iot_certfile) |> to_charlist,
        cacerts: :certifi.cacerts(),
        depth: 99,
        versions: [:"tlsv1.2"],
        customize_hostname_check: [
          match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
        ]
      },
      subscriptions: [{"plants/+/data", 0}]
    )

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HappyTree.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HappyTreeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
