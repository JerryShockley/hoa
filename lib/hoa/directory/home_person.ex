defmodule Hoa.Directory.HomePerson do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hoa.Directory.Person
  alias Hoa.Directory.Home

  schema "homes_people" do
    belongs_to :home, Home
    belongs_to :person, Person

    timestamps()
  end

  @doc false
  def changeset(home_person, attrs) do
    home_person
    |> cast(attrs, [:home_id, :person_id])
    |> validate_required([:home_id, :person_id])
  end
end
