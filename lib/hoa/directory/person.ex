defmodule Hoa.Directory.Person do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hoa.Directory.Home
  alias Hoa.Directory.HomePerson
  import Date
  import Utils.CustomValidations

  @required_fields ~w(first_name last_name home_relationship)a
  @optional_fields ~w(middle_name nickname name_suffix mobile_phone work_phone \
    home_phone email mobile_phone_public work_phone_public home_phone_public \
    email_public bio dob image_path mail_addressee street1 street2 city state \
    postal_code country_code)a
  use Utils.SchemaUtils

  schema "people" do
    field :first_name, :string
    field :middle_name, :string
    field :last_name, :string
    field :nickname, :string
    field :name_suffix, :string
    field :mobile_phone, :string
    field :work_phone, :string
    field :home_phone, :string
    field :email, :string
    field :mobile_phone_public, :boolean, default: false
    field :work_phone_public, :boolean, default: false
    field :home_phone_public, :boolean, default: false
    field :email_public, :boolean, default: false
    field :bio, :string
    field :dob, :date
    field :home_relationship, Ecto.Enum, values: [:owner, :renter, :child, :other]
    field :image_path, :string
    field :mail_addressee, :string
    field :street1, :string
    field :street2, :string
    field :city, :string
    field :state, :string
    field :postal_code, :string
    field :country_code, :string, default: "US"
    many_to_many(:homes, Home, join_through: HomePerson)

    timestamps()
  end

  @doc false
  def changeset(person, params \\ %{}) do
    person
    |> cast(params, fields(:all))
    |> validate_required(fields(:required))
    |> update_change(:mobile_phone, &remove_phone_formatting/1)
    |> update_change(:work_phone, &remove_phone_formatting/1)
    |> update_change(:home_phone, &remove_phone_formatting/1)
    |> validate_length(:mobile_phone, is: 10)
    |> validate_length(:work_phone, is: 10)
    |> validate_length(:home_phone, is: 10)
    |> validate_format(
      :email,
      ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
    )
    |> unique_constraint(:mobile_phone)
    |> unique_constraint(:work_phone)
    |> unique_constraint(:home_phone)
    |> unique_constraint(:email)
    |> validate_inclusion(:home_relationship, [:owner, :renter, :child, :other])
    |> validate_date_in_range(:dob, ~D[1900-01-01], utc_today())
    |> cast_assoc(:homes, with: &Hoa.Directory.Home.changeset/2)
  end

  def remove_phone_formatting(phone_str) when byte_size(phone_str) > 0 do
    String.replace(phone_str, ~r/[^0-9]/, "")
  end

  def remove_phone_formatting(_phone_str), do: nil

end
