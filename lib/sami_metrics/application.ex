defmodule SamiMetrics.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    :ok = :telemetry.attach("my-app-handler-id", [:sami_metrics, :repo, :query], &SamiMetricsWeb.Telemetry.handle_event/4, %{})

    children = [
      # Start the Telemetry supervisor
      SamiMetricsWeb.Telemetry,
      # Start the Ecto repository
      SamiMetrics.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: SamiMetrics.PubSub},
      # Start Finch
      {Finch, name: SamiMetrics.Finch},
      # SamiMetrics.Peoples
      {Task.Supervisor, name: SamiMetrics.TaskSupervisor},

      # Start the Endpoint (http/https)
      SamiMetricsWeb.Endpoint
      # Start a worker by calling: SamiMetrics.Worker.start_link(arg)
      # {SamiMetrics.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SamiMetrics.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SamiMetricsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
