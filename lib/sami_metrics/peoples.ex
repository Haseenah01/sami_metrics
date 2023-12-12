defmodule SamiMetrics.Peoples do
  import Ecto.Query, warn: false
  alias SamiMetrics.Repo
  alias SamiMetrics.Peoples.People
  alias SamiMetrics.Peoples.People2
  alias SamiMetrics.Peoples.People3

  def insert_many do
    people_records = Repo.all(People2)

    people = Enum.map(people_records, fn person ->
      Task.async(fn ->
      %People3{} =
        %People3{}
        |> Map.put(:firstname, person.firstname)
        |> Map.put(:lastname, person.lastname)
        |> Map.put(:phone, person.phone)
        |> Map.put(:dob, person.dob)
        |> Repo.insert!()

         SamiMetrics.Inserting.get_connection_info()
    end)
  end)

    people
    |> Enum.map(&Task.await(&1, :infinity))
  end

  def insert do

    people_records = Repo.all(People)

    people = Enum.map(people_records, fn person ->
      Task.async(fn ->
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

    people
    |> Enum.map(&Task.await(&1))
  end

  def insert_all_data(number) do
    people_records = Repo.all(People)

    limited_records =
      Enum.take(people_records, number)

    people = Enum.map(limited_records, fn person ->
      Task.async(fn ->
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

      people
      |> Enum.map(&Task.await(&1))

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


  def delete_all_people3 do
    Repo.delete_all(People3)
  end


  def delete_all_data(number) do
    people_records = Repo.all(People2)

    limited_records = Enum.take(people_records, number)

    Enum.each(limited_records, fn _person ->
      Repo.delete_all(People2)
    end)
  end

  # def update_all_phones(number) do
  #   people_records =
  #     Repo.all(People2)
  #     |> Enum.take(number)

  #   Enum.each(people_records, fn person ->
  #     updated_person =
  #       %People2{person | phone: "0742570244"}
  #       |> Repo.update!()

  #     # You can inspect the updated_person if needed
  #     IO.inspect(updated_person, label: "Updated Person")
  #   end)
  # end



  def list_peoples do
    Repo.all(People2)
  end
end
