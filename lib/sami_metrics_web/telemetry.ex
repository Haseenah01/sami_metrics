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
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def handle_event([:sami_metrics, :repo, :query], measurements, metadata, config) do
    IO.inspect binding()
  end

  def handle_event([:sami_metrics, :database, :get_connection_info], measurements, metadata, config) do
    connection_info = SamiMetrics.Inserting.get_connection_info()
    emit_connection_stats(connection_info)
    :ok
  end

  def emit_connection_stats(connection_info) do
    :telemetry.execute(
      [:sami_metrics, :database, :total_connections],
      %{value: Map.get(connection_info, :total_connections, 0)}
    )

    :telemetry.execute(
      [:sami_metrics, :database, :busy_connections],
      %{value: Map.get(connection_info, :busy_connections, 0)}
    )

    :telemetry.execute(
      [:sami_metrics, :database, :idle_connections],
      %{value: Map.get(connection_info, :idle_connections, 0)}
    )
  end
  # def handle_event([:sami_metrics, :database, :total_connections], measurements, _metadata, _config) do
  #   count = Keyword.get(measurements, :total_connections, 0)
  #   SamiMetricsWeb.MetricsManager.increment("sami_metrics.database.total_connections", count)
  #   :ok
  # end

  # def handle_event([:sami_metrics, :database, :busy_connections], measurements, _metadata, _config) do
  #   count = Keyword.get(measurements, :busy_connections, 0)
  #   SamiMetricsWeb.MetricsManager.increment("sami_metrics.database.busy_connections", count)
  #   :ok
  # end

  # def handle_event([:sami_metrics, :database, :idle_connections], measurements, _metadata, _config) do
  #   count = Keyword.get(measurements, :idle_connections, 0)
  #   SamiMetricsWeb.MetricsManager.increment("sami_metrics.database.idle_connections", count)
  #   :ok
  # end
  # def handle_event([:sami_metrics, :database, :total_connections], measurements, _metadata, _config) do
  #   total_connections = Keyword.get(measurements, :total_connections, 0)
  #   update_metric_value(:total_connections, total_connections)
  #   emit_telemetry(:total_connections, total_connections)
  #   :ok
  # end

  # def handle_event([:sami_metrics, :database, :busy_connections], measurements, _metadata, _config) do
  #   busy_connections = Keyword.get(measurements, :busy_connections, 0)
  #   update_metric_value(:busy_connections, busy_connections)
  #   emit_telemetry(:busy_connections, busy_connections)
  #   :ok
  # end

  # def handle_event([:sami_metrics, :database, :idle_connections], measurements, _metadata, _config) do
  #   idle_connections = Keyword.get(measurements, :idle_connections, 0)
  #   update_metric_value(:idle_connections, idle_connections)
  #   emit_telemetry(:idle_connections, idle_connections)
  #   :ok
  # end

  # defp emit_telemetry(metric_type, value) do
  #   :telemetry.execute([:sami_metrics, :database, metric_type], %{value: value})
  # end

  def metrics do
    [
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

      # VM Metrics
      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io"),

      # Add a metric for the number of database connections
      # summary("sami_metrics.repo.connections", unit: :count, description: "Number of database connections"),
      # counter("sami_metrics.repo.connections.count")
      # counter("sami_metrics.repo.pool_size.count"),
      # counter("sami_metrics.repo.queue_size.count"),
      # counter("sami_metrics.repo.checked_out.count")
      # counter("sami_metrics.database.total_connections.value"),
      # counter("sami_metrics.database.busy_connections.value"),
      # counter("sami_metrics.database.idle_connections.value")
      summary("sami_metrics.database.total_connections", unit: :count, description: "Number of total database connections"),
    summary("sami_metrics.database.busy_connections", unit: :count, description: "Number of busy database connections"),
    summary("sami_metrics.database.idle_connections", unit: :count, description: "Number of idle database connections")
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
  # defp update_metric_value(metric_type, value) do
  #   GenServer.cast(__MODULE__, {:update_metric, metric_type, value})
  # end

  # defp start_link(_) do
  #   GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  # end

  # defp init(nil) do
  #   {:ok, %{total_connections: 0, busy_connections: 0, idle_connections: 0}}
  # end

  # defp handle_cast({:update_metric, :total_connections, value}, state) do
  #   {:noreply, Map.put(state, :total_connections, value)}
  # end

  # defp handle_cast({:update_metric, :busy_connections, value}, state) do
  #   {:noreply, Map.put(state, :busy_connections, value)}
  # end

  # defp handle_cast({:update_metric, :idle_connections, value}, state) do
  #   {:noreply, Map.put(state, :idle_connections, value)}
  # end
end
