defmodule Hoa.Directory.Person do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hoa.Directory.Home
  import Date
  import Utils.CustomValidations

  schema "people" do
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :nickname, :string
    field :mobile_phone, :string
    field :work_phone, :string
    field :email, :string
    field :mobile_phone_public, :boolean, default: false
    field :work_phone_public, :boolean, default: false
    field :email_public, :boolean, default: false
    field :bio, :string
    field :dob, :date
    field :home_relationship, Ecto.Enum, values: [:owner, :renter, :child, :other]
    field :image_path, :string
    belongs_to :home, Home

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:first_name, :last_name, :mobile_phone, :email, :mobile_phone_public,
          :email_public, :bio, :dob, :home_relationship, :middle_name, :nickname,
          :image_path, :work_phone, :work_phone_public])
    |> validate_required([:first_name, :last_name, :mobile_phone_public,
          :work_phone_public, :email_public, :home_relationship ])
    |> update_change(:mobile_phone, &remove_phone_formatting/1)
    |> update_change(:work_phone, &remove_phone_formatting/1)
    |> validate_length(:mobile_phone, is: 10)
    |> validate_length(:work_phone, is: 10)
    |> validate_format(:email,
          ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_inclusion(:home_relationship, [:owner, :renter, :child, :other])
    |> validate_date_in_range(:dob, ~D[1900-01-01], utc_today())
  end

  def remove_phone_formatting(phone_str) when byte_size(phone_str) > 0 do
    String.replace(phone_str, ~r/[^0-9]/, "")
  end
  def remove_phone_formatting(_phone_str), do: nil
end
