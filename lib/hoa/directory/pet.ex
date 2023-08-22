defmodule Hoa.Directory.Pet do
  use Ecto.Schema
  import Ecto.Changeset
  import Utils.CustomValidations
  alias Hoa.Directory.Home
  import Date

  schema "pets" do
    field :name, :string
    field :type, Ecto.Enum, values: [:dog, :cat]
    field :breed, :string
    field :dob, :date
    field :weight, :integer
    field :image_path, :string
    belongs_to :home, Home

    timestamps()
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name, :type, :breed, :image_path,
        :dob, :weight])
    |> validate_required([:name, :type, :breed])
    |> validate_number(:weight, greater_than: 3)
    |> validate_date_in_range(:dob, Date.add(utc_today(), -365 * 20), utc_today())
  end
end
