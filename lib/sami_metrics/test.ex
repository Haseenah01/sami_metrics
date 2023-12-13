defmodule SamiMetrics.Test do
  alias SamiMetrics.Repo
  alias SamiMetrics.Peoples.People
  alias SamiMetricsWeb.Metrics
  require Logger


  @timeout 60000

  def start() do

    people_records = Repo.all(People)
    #limit = Enum.count(people_records)
    task = Enum.map(people_records, fn person -> do_insert_async(person)  end)
    Enum.map(task, &await_and_inspect(&1))
    # Enum.each(tasks, &await_and_inspect/1)

    {_total_count, _elapsed_time_ms, _} = Metrics.Telemetry.ReporterState.value()
    Logger.info("")
    # IO.inspect(total_count)
    #|> Enum.each(fn task -> await_and_inspect(task) end)
  end

  defp do_insert_async(person) do
    Task.async(fn ->
      :poolboy.transaction(
        :worker,
        fn pid ->
          try do
            Metrics.count()
            GenServer.call(pid, {:insert, person})
          catch
            e, r -> IO.inspect("poolboy transaction caught error: #{inspect(e)}, #{inspect(r)}")
            :ok
          end
        end,
        @timeout
      )
    end)
  end

  defp await_and_inspect(task) do
    # Wait for the task to complete and inspect the result if needed
    case Task.await(task, @timeout) do
      {:ok, result} -> IO.inspect(result)
      {:error, reason} -> IO.inspect("Task failed with reason: #{reason}")
    end
  end
end
