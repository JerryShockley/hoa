defmodule Hoa.Directory.Home do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hoa.Directory.{Person, Pet, HomePerson}

  @required_fields ~w(home_name rental)a
  @optional_fields ~w(lot_number)a
  use Utils.SchemaUtils

  schema "homes" do
    field :home_name, :string
    field :lot_number, :string
    field :rental, :boolean, default: false

    many_to_many(:people, Person, join_through: HomePerson)
    has_many :pets, Pet, foreign_key: :home_id

    timestamps()
  end



  def changeset(home, params \\ %{}) do
    home
    |> cast(params, fields(:all))
    |> validate_required(fields(:required))
    |> unique_constraint(:home_name)
  end
end
