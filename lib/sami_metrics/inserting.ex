defmodule SamiMetrics.Inserting do
  # import Ecto.Query

  import Ecto.Query, warn: false
  # alias SamiMetrics.Peoples.People2
   alias SamiMetrics.Repo
  # alias SamiMetrics.Peoples.People
  # alias SamiMetrics.Peoples.People2
   alias SamiMetrics.Peoples
  #  require Logger

#   def perform_insert_update_delete() do
#     # Assuming you have already configured your database connection in config/dev.exs or config/prod.exs
#     # {:ok, _pid} = Application.ensure_all_started(:sami_metrics)
#     #{:ok, repo} = SamiMetrics.Repo.start_link()

#     case SamiMetrics.Repo.start_link() do
#       {:ok, _repo} ->
#         IO.puts("Repo started successfully.")

#     # IO.inspect(connection_info)
#       {:error, {:already_started}} ->
#         IO.puts("Repo is already started.")


#     # Execute an insert, update, or delete query
#     # query = "INSERT INTO people2 (id, firstname, lastname, phone, dob, inserted_at, updated_at) VALUES ('0000124a-324d-471a-83ff-21c40dc1ad0c', 'godfrey', 'Mutshinyane', '075-999-8090', '1999-08-28', '2023-11-24 08:57:59', '2023-11-24 08:57:59');"
#     # query = SamiMetrics.Peoples.insert_all_data

#     # Ecto.Adapters.SQL.query!(repo, query)
#      Peoples.insert_all_data()
#     # Retrieve information about connections
#     get_connection_info()
#    # append_to_file("/home/godfrey/tests/sami_metrics/lib/connection_info.txt", connection_info)
#     # Display the information

#       other ->
#         IO.puts("Unexpected error: #{inspect(other)}")
#     end


#     # # Execute an insert, update, or delete query
#     # query = "INSERT INTO people (firstname, lastname, phone, dob) VALUES (godfrey, Mutshinyane, 075-999-8090, 1999-08-28);"
#     # # query = SamiMetrics.Peoples.insert_all_data

#     # Ecto.Adapters.SQL.query!(repo, query)

#     # # Retrieve information about connections
#     # connection_info = get_connection_info()

#     # # Display the information
#     # IO.inspect(connection_info)

#      # Append the information to a text file

#   end

#   defp emit_telemetry(total_connections, busy_connections, idle_connections) do
#     :telemetry.execute(
#       [:sami_metrics, :database],
#       %{
#         total_connections: total_connections,
#         busy_connections: busy_connections,
#         idle_connections: idle_connections
#       }
#     )
#   end




#   defp get_connection_info() do
#     query = "SELECT
#     state,
#     COUNT(*) AS state_count
# FROM
#     pg_stat_activity
# WHERE
#     datname = 'sami_metrics_dev'
# GROUP BY
#     state
# ORDER BY
#     state;"
#     result = Ecto.Adapters.SQL.query!(SamiMetrics.Repo, query)

#     # Filter connections based on their activity
    # total_connections = length(result.rows)
#     busy_connections = Enum.filter(result.rows, &(&1[:state] != "idle"))
#     idle_connections = Enum.filter(result.rows, &(&1[:state] == "idle"))

#     # Display the number of connections and their details
#     IO.puts("Total Connections: #{total_connections}")
#   IO.puts("Busy Connections: #{length(busy_connections)}")
#    IO.puts("Idle Connections: #{length(idle_connections)}")

#     # Display details of busy connections
#     # IO.puts("Busy Connections Details:")
#     # Enum.each(busy_connections, fn(conn) ->
#     #   conn
#     # end)

#     # Display details of idle connections
#     # IO.puts("Idle Connections Details:")
#     # Enum.each(idle_connections, fn(conn) ->
#     #   conn
#     # end)

#     # Return connection information

#     emit_telemetry(total_connections, busy_connections, idle_connections)
#     result.rows
#   end

#   # defp append_to_file(file_path, content) do
#   #   File.write!(file_path, content, [:append])
#   # end

# end

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
   # append_to_file("/home/godfrey/tests/sami_metrics/lib/connection_info.txt", connection_info)
    # Display the information

  other ->
    IO.puts("Unexpected error: #{inspect(other)}")
  end


    # # Execute an insert, update, or delete query
    # query = "INSERT INTO people (firstname, lastname, phone, dob) VALUES (godfrey, Mutshinyane, 075-999-8090, 1999-08-28);"
    # # query = SamiMetrics.Peoples.insert_all_data

    # Ecto.Adapters.SQL.query!(repo, query)

    # # Retrieve information about connections
    # connection_info = get_connection_info()

    # # Display the information
    # IO.inspect(connection_info)

     # Append the information to a text file

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

    # Filter connections based on their activity
    busy_connections = Enum.filter(result.rows, &(&1[:state] != "idle"))
    idle_connections = Enum.filter(result.rows, &(&1[:state] == "idle"))

    # Display the number of connections and their details
    IO.puts("Total Connections: #{length(result.rows)}")
    IO.puts("Busy Connections: #{length(busy_connections)}")
    IO.puts("Idle Connections: #{length(idle_connections)}")

    # Display details of busy connections
    # IO.puts("Busy Connections Details:")
    # Enum.each(busy_connections, fn(conn) ->
    #   conn
    # end)

    # Display details of idle connections
    # IO.puts("Idle Connections Details:")
    # Enum.each(idle_connections, fn(conn) ->
    #   conn
    # end)

    # Return connection information
    result.rows
  end

  # defp append_to_file(file_path, content) do
  #   File.write!(file_path, content, [:append])
  # end

end
