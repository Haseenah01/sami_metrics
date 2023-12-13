defmodule SamiMetricsWeb.Telemetry do
  use Supervisor
  import Telemetry.Metrics
  # require Logger
  # import Telemetry.Metrics.Measurement

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      # Telemetry poller will execute the given period measurements
      # every 10_000ms. Learn more here: https://hexdocs.pm/telemetry_metrics
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000},
      # Add reporters as children of your supervision tree.
      # {Telemetry.Metrics.ConsoleReporter, metrics: metrics()}
      # {Metrics.Telemetry.CustomReporter, metrics: metrics()}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def handle_event([:sami_metrics, :repo, :query], measurements, _metadata, _config) do
    IO.inspect measurements
  end

  def metrics do
    [
      #custom counter -> Number of queries
      counter("metrics.count.count"),
      # Phoenix Metrics
      summary("phoenix.endpoint.start.system_time",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.start.system_time",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.exception.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      summary("phoenix.socket_connected.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.channel_joined.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.channel_handled_in.duration",
        tags: [:event],
        unit: {:native, :millisecond}
      ),

      # Database Metrics
      summary("sami_metrics.repo.query.total_time",
        unit: {:native, :millisecond},
        description: "The sum of the other measurements"
      ),
      summary("sami_metrics.repo.query.decode_time",
        unit: {:native, :millisecond},
        description: "The time spent decoding the data received from the database"
      ),
      summary("sami_metrics.repo.query.query_time",
        unit: {:native, :millisecond},
        description: "The time spent executing the query"
      ),
      summary("sami_metrics.repo.query.queue_time",
        unit: {:native, :millisecond},
        description: "The time spent waiting for a database connection"
      ),
      summary("sami_metrics.repo.query.idle_time",
        unit: {:native, :millisecond},
        description:
          "The time the connection spent waiting before being checked out for the query"
      ),

      last_value("sami_metrics.process.message_queue_length",
      unit: {:byte, :megabyte}),


      # VM Metrics
      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io")

    ]
  end

  defp periodic_measurements do
    [
      # A module, function and arguments to be invoked periodically.
      # This function must call :telemetry.execute/3 and a metric must be added above.
      # {SamiMetricsWeb, :count_users, []}
      # {SamiMetrics, :connection_metrics, []}
      # {SamiMetrics.Inserting, :get_connection_info}
      # {SamiMetricsWeb.Telemetry, :get_connection_info, []}
      # {SamiMetricsWeb.Telemetry, :emit_connection_stats, []}

    ]
  end

end
