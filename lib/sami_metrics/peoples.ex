defmodule SamiMetrics.Peoples do
  import Ecto.Query, warn: false
  alias SamiMetrics.Repo
  alias SamiMetrics.Peoples.People
  alias SamiMetrics.Peoples.People2
  # alias SamiMetricsWeb.DBConnectionListener


  def insert_all_data do
    people_records = Repo.all(People)

    Enum.each(people_records, fn person ->
      %People2{} =
        %People2{}
        |> Map.put(:firstname, person.firstname)
        |> Map.put(:lastname, person.lastname)
        |> Map.put(:phone, person.phone)
        |> Map.put(:dob, person.dob)
        |> Repo.insert!()
    end)
  end

  # def insert_all_data do
  #   query =
  #     "INSERT INTO people2 (id, firstname, lastname, phone, dob, inserted_at, updated_at ) " <>
  #     "SELECT id, firstname, lastname, phone, dob, inserted_at, updated_at FROM people;"

  #   Ecto.Adapters.SQL.query!(Repo, query)
  # end

  def delete_all_data do
    Repo.delete_all(People2)
  end

  def update_all_phones do
    query = from(p in People2, update: [set: [phone: "0742570244"]])

    |> Repo.update_all([])
  end

  def list_peoples do
    Repo.all(People2)
  end
end
