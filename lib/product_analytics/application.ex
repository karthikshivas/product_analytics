defmodule ProductAnalytics.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ProductAnalyticsWeb.Telemetry,
      ProductAnalytics.Repo,
      {DNSCluster, query: Application.get_env(:product_analytics, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ProductAnalytics.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ProductAnalytics.Finch},
      # Start a worker by calling: ProductAnalytics.Worker.start_link(arg)
      # {ProductAnalytics.Worker, arg},
      # Start to serve requests, typically the last entry
      ProductAnalyticsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ProductAnalytics.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ProductAnalyticsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
