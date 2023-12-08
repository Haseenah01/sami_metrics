defmodule SamiMetrics.Inserting do

  import Ecto.Query, warn: false

   alias SamiMetrics.Peoples


def perform_insert_update_delete do
    # Assuming you have already configured your database connection in config/dev.exs or config/prod.exs
    {:ok, _pid} = Application.ensure_all_started(:sami_metrics)
    #{:ok, repo} = SamiMetrics.Repo.start_link()

    case SamiMetrics.Repo.start_link() do
      {:ok, _repo} ->
        IO.puts("Repo started successfully.")

    # IO.inspect(connection_info)
      {:error, {:already_started, _repo}} ->
        IO.puts("Repo is already started.")

    # Execute an insert, update, or delete query
    # query = "INSERT INTO people2 (id, firstname, lastname, phone, dob, inserted_at, updated_at) VALUES ('0000124a-324d-471a-83ff-21c40dc1ad0c', 'godfrey', 'Mutshinyane', '075-999-8090', '1999-08-28', '2023-11-24 08:57:59', '2023-11-24 08:57:59');"
    # query = SamiMetrics.Peoples.insert_all_data

    # Ecto.Adapters.SQL.query!(repo, query)
     Peoples.insert_all_data()
    # Retrieve information about connections
    _connection_info = get_connection_info()


  other ->
    IO.puts("Unexpected error: #{inspect(other)}")
  end

  end

  def get_connection_info() do
    query = "SELECT
    state,
    COUNT(*) AS state_count
FROM
    pg_stat_activity
WHERE
    datname = 'sami_metrics_dev'
GROUP BY
    state
ORDER BY
    state;"

    result = Ecto.Adapters.SQL.query!(SamiMetrics.Repo, query)

    case result.rows do
      [["active", active], ["idle", idle]| _t] ->
        File.write("connections.log", "Total Connections: #{active + idle} | Active: #{active} | Idle: #{idle} \n", [:append, {:delayed_write, 1000000, 20}])

      _ ->
    end
  end
end
