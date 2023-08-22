defmodule Hoa.Directory.Home do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hoa.Directory.Person
  alias Hoa.Directory.Pet

  schema "homes" do
    field :home_name, :string
    field :lot_number, :string
    field :home_phone, :string
    field :home_phone_public, :boolean, default: false
    field :rental, :boolean, default: false
    field :addressee, :string
    field :street1, :string
    field :street2, :string
    field :city, :string
    field :state_code, :string
    field :postal_code, :string
    field :country_code, :string, default: "US"
    has_many :people, Person, foreign_key: :home_id
    has_many :pets, Pet, foreign_key: :home_id

    timestamps()
  end

  @doc false
  def changeset(home, attrs) do
    home
    |> cast(attrs, [:home_name, :lot_number, :home_phone, :home_phone_public,
        :addressee, :rental, :street1, :street2, :city, :state_code,
        :postal_code, :country_code])
    |> validate_required([:home_name, :home_phone_public, :rental])
    |> cast_assoc(:people)
    |> cast_assoc(:pets)
  end
end
