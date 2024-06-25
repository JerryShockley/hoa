defmodule Hoa.Directory.Home do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias Hoa.Directory.{Person, Pet, HomePerson}


  schema "homes" do
    field :home_name, :string
    field :lot_number, :string
    field :rental, :boolean, default: false

    many_to_many(:people, Person, join_through: HomePerson)
    has_many :pets, Pet, foreign_key: :home_id

    timestamps()
  end

  @doc false
  def changeset(home, params \\ %{}) do
    home
    |> cast(params, [ :home_name, :lot_number, :rental ])
    |> validate_required([:home_name])
    |> unique_constraint(:home_name)
    |> cast_assoc(:people)
    |> cast_assoc(:pets)
  end

  defp base do
    from _ in Hoa.Directory.Home, as: :home
  end

  def all(query \\ base()), do: query

  def where_id(query \\ base(), id) do
    from h in query,
      where: h.id == ^id
  end

  def search(query \\ base(), opts \\ []) do
    srch_params = Keyword.get(opts, :srch_params, [])
      from e in query,
      where: ^srch_params
  end

  @spec with_people(any()) :: Ecto.Query.t()
  def with_people(query \\ base()) do
    from e in query,
      join: p in assoc(e, :people),
      preload: [people: p]
  end

  def with_pets(query \\ base()) do
    from e in query,
      join: t in assoc(e, :pets),
      preload: [pets: t]
  end
end
