defmodule SamiMetrics.Worker do
  alias SamiMetrics.Repo
  alias SamiMetrics.Peoples.People2

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:square_root, x}, _from, state) do
    IO.puts("process #{inspect(self())} calculating square root of #{x}")
    Process.sleep(1000)
    {:reply, :math.sqrt(x), state}
  end

  def handle_call({:insert, person}, _from, _state) do
    insert(person)
    {:reply, :ok, :ok}
  end

  def insert(person) do

      %People2{} =
        %People2{}
        |> Map.put(:firstname, person.firstname)
        |> Map.put(:lastname, person.lastname)
        |> Map.put(:phone, person.phone)
        |> Map.put(:dob, person.dob)
        |> Repo.insert!()

         SamiMetrics.Inserting.get_connection_info()
  end
end
