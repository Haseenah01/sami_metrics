defmodule SamiMetrics.Repo do
  use Ecto.Repo,
    otp_app: :sami_metrics,
    adapter: Ecto.Adapters.Postgres

    @replicas [
      SamiMetrics.Repo.Replica
    ]


    def replica do
      Enum.random(@replicas)
    end


    for repo <- @replicas do
      defmodule repo do
        use Ecto.Repo,
          otp_app: :sami_metrics,
          adapter: Ecto.Adapters.Postgres,
          read_only: true
      end
    end


  # defp connection_metrics do
  #   # Assuming you have a method to retrieve the number of connections from your Repo
  #   {:ok, connections} = Ecto.Adapters.SQL.query!(
  #     __MODULE__,
  #     "SELECT COUNT(*) FROM pg_stat_activity WHERE datname = sami_metrics_dev()",
  #     []
  #   )

  #   # Specify the count (you can make it dynamic based on your logic)
  #   count = connections |> List.first() |> Map.get("count", 0)

  #   Logger.debug("DB Connection Metrics - Connections: #{count}")

  #   :ok
  # end

  # def handle_event([:sami_metrics, :repo, :query], _measurements, _metadata, _config) do
  #   connection_metrics()
  # end

  # def connection_metrics([]) do
  #   Logger.warn("Empty measurements in connection_metrics/1")
  #   :ok
  # end

  # def connection_metrics(measurements) do
  #   IO.inspect(measurements, label: "Measurements before case")

  #   case measurements do
  #     [%{idle_time: idle_time, decode_time: decode_time, queue_time: queue_time, query_time: query_time, total_time: total_time} | _rest] ->
  #       {repo, _} = measurements[0]

  #       # Access the metrics directly from measurements with default values
  #       pool_size = Map.get(measurements, "db_connection.pool_size", 0)
  #       queue_size = Map.get(measurements, "db_connection.queue_size", 0)
  #       checked_out = Map.get(measurements, "db_connection.checked_out", 0)

  #       Logger.debug("DB Connection Metrics - Repo: #{repo}, Pool Size: #{pool_size}, Queue Size: #{queue_size}, Checked Out: #{checked_out}")

  #       :ok

  #     _ ->
  #       Logger.warn("Empty or invalid measurements in connection_metrics/1")
  #       :error
  #   end
  # end

  # def handle_event([:sami_metrics, :repo, :query], measurements, _metadata, _config) do
  #   connection_metrics(measurements)
  # end

end
