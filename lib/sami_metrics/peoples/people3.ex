defmodule SamiMetrics.Peoples.People3 do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  # @derive {Enumerable, only: [:id, :phone, :firstname, :lastname, :address]}
  schema "people3" do
    field :firstname, :string
    field :lastname, :string
    field :phone, :string
    field :dob, :string

    timestamps()
  end

  @doc false
  def changeset(people3, attrs) do
    people3
    |> cast(attrs, [:firstname, :lastname, :phone, :dob])
    |> validate_required([:firstname, :lastname, :phone, :dob])
  end
end
