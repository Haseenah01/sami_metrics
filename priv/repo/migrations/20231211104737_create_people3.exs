defmodule SamiMetrics.Repo.Migrations.CreatePeople3 do
  use Ecto.Migration

  def change do
    create table(:people3, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :firstname, :string
      add :lastname, :string
      add :phone, :string
      add :dob, :string
      timestamps()
  end
  end
end
