defmodule SamiMetrics.Test do
  alias SamiMetrics.Repo
  alias SamiMetrics.Peoples.People
  
  @timeout 60000

  def start() do

    people_records = Repo.all(People)
    #limit = Enum.count(people_records)
    Enum.map(people_records, fn person -> do_insert_async(person)  end)
    #|> Enum.each(fn task -> await_and_inspect(task) end)
  end

  defp do_insert_async(person) do
    Task.async(fn ->
      :poolboy.transaction(
        :worker,
        fn pid ->
          # Let's wrap the genserver call in a try - catch block. This allows us to trap any exceptions
          # that might be thrown and return the worker back to poolboy in a clean manner. It also allows
          # the programmer to retrieve the error and potentially fix it.
          try do
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
end
