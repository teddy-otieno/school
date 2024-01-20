defmodule School.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SchoolWeb.Telemetry,
      School.Repo,
      {DNSCluster, query: Application.get_env(:school, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: School.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: School.Finch},
      # Start a worker by calling: School.Worker.start_link(arg)
      # {School.Worker, arg},
      # Start to serve requests, typically the last entry
      SchoolWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: School.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SchoolWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
