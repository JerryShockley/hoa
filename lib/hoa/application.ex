defmodule Hoa.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      HoaWeb.Telemetry,
      # Start the Ecto repository
      Hoa.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Hoa.PubSub},
      # Start Finch
      {Finch, name: Hoa.Finch},
      # Start the Endpoint (http/https)
      HoaWeb.Endpoint
      # Start a worker by calling: Hoa.Worker.start_link(arg)
      # {Hoa.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hoa.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HoaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
