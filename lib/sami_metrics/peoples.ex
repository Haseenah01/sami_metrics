defmodule SamiMetrics.Peoples do
  import Ecto.Query, warn: false
  alias SamiMetrics.Repo
  alias SamiMetrics.Peoples.People
  alias SamiMetrics.Peoples.People2
  alias SamiMetrics.Inserting


  # use GenServer

  # def start_link(_) do
  #   GenServer.start_link(__MODULE__, nil)
  # end

  # def init(_) do
  #   {:ok, nil}
  # end

  # def insert_all_data do
  #   GenServer.call(__MODULE__, :insert_all_data)
  # end

  # def poolboy_with_task do
  #   GenServer.call(__MODULE__, :poolboy_with_task)
  # end

  # def poolboy do
  #   GenServer.call(__MODULE__, :poolboy)
  # end

  # def handle_call(:insert_all_data, _from, _state) do
  #   people_records = Repo.all(People)

  #   people = Enum.each(people_records, fn person ->
  #     Task.async(fn ->
  #     %People2{} =
  #       %People2{}
  #       |> Map.put(:firstname, person.firstname)
  #       |> Map.put(:lastname, person.lastname)
  #       |> Map.put(:phone, person.phone)
  #       |> Map.put(:dob, person.dob)
  #       |> Repo.insert!()

  #        SamiMetrics.Inserting.get_connection_info()
  #   end)
  # end)

  # Task.await(people)

  #   {:reply, :ok, nil}
  # end

  # def handle_call(:poolboy_with_task, _from, _pool) do
  #   task =
  #     Task.async(fn ->
  #       :poolboy.transaction(:peoples, fn worker ->
  #         :gen_server.call(worker, :insert_all_data)
  #       end)
  #     end)

  #   {:reply, task, _pool}
  # end

  # def poolboy_with_task do
  #   Task.async(fn ->
  #     :poolboy.transaction(:peoples, fn worker ->
  #       :gen_server.call(worker, :insert_all_data)
  #     end)
  #   end)

  # end

  # def poolboy do
  #   :poolboy.transaction(:peoples, fn worker ->
  #     :gen_server.call(worker, :insert_all_data)
  #   end)
  # end
  # def handle_call(:poolboy, _from, _pool) do
  #   :poolboy.transaction(:peoples, fn worker ->
  #     :gen_server.call(worker, :insert_all_data)
  #   end)

  #   {:reply, nil, _pool}
  # end


  def insert do

    {:ok, pid} = Task.Supervisor.start_link()

    people_records = Repo.all(People)

    people = Enum.each(people_records, fn person ->
      Task.Supervisor.async(pid, fn ->
      %People2{} =
        %People2{}
        |> Map.put(:firstname, person.firstname)
        |> Map.put(:lastname, person.lastname)
        |> Map.put(:phone, person.phone)
        |> Map.put(:dob, person.dob)
        |> Repo.insert!()

         SamiMetrics.Inserting.get_connection_info()
        # :telemetry.execute([:sami_metrics, :process, :message_queue_length], %{pid: pid})
    end)
  end)

  Task.await(people)

    # :poolboy.transaction(:peoples, fn worker -> :gen_server.call(worker, people) end)
  end

  # def start_link(_) do
  #   Supervisor.start_link(__MODULE__, nil)
  # end

  # def init(nil) do
  #   children = [
  #     :poolboy.child_spec(:worker, Application.poolboy_config())
  #   ]

  #   Supervisor.init(children, strategy: :one_for_one)
  # end


  def insert_all_data(number) do
    people_records = Repo.all(People)

    limited_records =
      Enum.take(people_records, number)


    Enum.each(limited_records, fn person ->
       Task.async(fn ->
        :poolboy.transaction(:peoples, fn pid ->
          %People2{} =
            %People2{}
            |> Map.put(:firstname, person.firstname)
            |> Map.put(:lastname, person.lastname)
            |> Map.put(:phone, person.phone)
            |> Map.put(:dob, person.dob)
            |> Repo.insert!()

            SamiMetrics.Inserting.get_connection_info()
        end)
      end)
     end)

    # Enum.map(&Task.await/1)
  end


  # def insert_all_data do
  #   query =
  #     "INSERT INTO people2 (id, firstname, lastname, phone, dob, inserted_at, updated_at ) " <>
  #     "SELECT id, firstname, lastname, phone, dob, inserted_at, updated_at FROM people;"

  #   Ecto.Adapters.SQL.query!(Repo, query)
  # end

  def delete_all do
    Repo.delete_all(People2)
  end

  def delete_all_data(number \\ :infinity) do
    people_records =
      Repo.all(People2)

      limited_records =
        Enum.take(people_records, number)

    Enum.each(limited_records, fn person ->
      Repo.delete_all(People2)
    end)
  end



  # def update_all_phones do
  #   query = from(p in People2, update: [set: [phone: "0742570244"]])

  #   |> Repo.update_all([])
  # end

  def update_all_phones(number \\ :infinity) do
    people_records =
      Repo.all(People2)
      |> Enum.take(number)

    Enum.each(people_records, fn person ->
      updated_person =
        %People2{person | phone: "0742570244"}
        |> Repo.update!()

      # You can inspect the updated_person if needed
      IO.inspect(updated_person, label: "Updated Person")
    end)
  end



  def list_peoples do
    Repo.all(People2)
  end
end
